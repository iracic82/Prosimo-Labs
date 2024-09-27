from azure.identity import ClientSecretCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.network.models import Route
import os

# Replace with your subscription ID
subscription_id = os.environ.get("INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_SUBSCRIPTION_ID")

# Authenticate using ClientSecretCredential
credential = ClientSecretCredential(
    client_id=os.getenv("INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_SPN_ID"),
    tenant_id=os.getenv("INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_TENANT_ID"),
    client_secret=os.getenv("INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_SPN_PASSWORD")
)

# Resource Management Client
resource_client = ResourceManagementClient(credential, subscription_id)

# Network Management Client
network_client = NetworkManagementClient(credential, subscription_id)

# Get next hop from Firewall table
resource_group_name = 'Lab-Firewall-RG'
route_table_name = 'Firewall-Route-Table'

try:
    # Get the route table
    route_table = network_client.route_tables.get(resource_group_name, route_table_name)
    if route_table.routes:
        nexthopip = route_table.routes[0].next_hop_ip_address
        print(f"Next Hop {nexthopip}")
    else:
        print("No routes found in the route table")
except Exception as e:
    print(f"Error retrieving route table: {e}")

# Update Edge Route Table
try:
    resource_groups = resource_client.resource_groups.list()

    # New routes to add
    new_route_1 = Route(
        name='returnTraffic_10_0',  # Unique name for the first route
        address_prefix='10.0.0.100/32',
        next_hop_type='VirtualAppliance',
        next_hop_ip_address=nexthopip
    )

    new_route_2 = Route(
        name='forwardTraffic_10_2',  # Unique name for the second route
        address_prefix='10.2.0.100/32',
        next_hop_type='VirtualAppliance',
        next_hop_ip_address=nexthopip
    )

    for rg in resource_groups:
        if rg.location == 'northeurope' and "connector" in rg.name:
            conn_rg = rg.name
            print(f"Resource Group: {rg.name}, Location: {rg.location}")

            conn_route_tables = network_client.route_tables.list(conn_rg)
            route_table = next(conn_route_tables, None)

            if route_table:
                print(f"Route Table Name: {route_table.name}")

                for route in route_table.routes:
                    print(f" - Route Name: {route.name}, Next Hop Type: {route.next_hop_ip_address}")
                    route.next_hop_ip_address = "10.160.1.4"

                # Apply the first route
                try:
                    print(f"Adding route: {new_route_1.name}")
                    poller = network_client.routes.begin_create_or_update(conn_rg, route_table.name, new_route_1.name, new_route_1)
                    poller.result()  # Wait for completion
                    print(f"Route {new_route_1.name} added successfully.")
                except Exception as e:
                    print(f"Error adding {new_route_1.name}: {e}")

                # Apply the second route
                try:
                    print(f"Adding route: {new_route_2.name}")
                    poller = network_client.routes.begin_create_or_update(conn_rg, route_table.name, new_route_2.name, new_route_2)
                    poller.result()  # Wait for completion
                    print(f"Route {new_route_2.name} added successfully.")
                except Exception as e:
                    print(f"Error adding {new_route_2.name}: {e}")

except Exception as e:
    print(f"Error updating route table: {e}")