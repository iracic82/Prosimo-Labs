

# Create EC2 and Networking Infrastructure in AWS


module "aws__instances_eu" {
  source = "./modules/aws-resources"
  providers         = {   
  aws = aws.eu-west-1
  }
  for_each              = var.EU_West_FrontEnd
  aws_region            = var.aws_region[0]
  aws_vpc_name          = each.value["aws_vpc_name"]
  aws_subnet_name       = each.value["aws_subnet_name"]
  rt_name               = each.value["rt_name"]
  igw_name              = each.value["igw_name"]
  private_ip            = each.value["private_ip"]
  tgw                   = "false"
  aws_ec2_name          = each.value["aws_ec2_name"]
  aws_ec2_key_pair_name = each.value["aws_ec2_key_pair_name"]

  aws_vpc_cidr    = each.value["aws_vpc_cidr"]
  aws_subnet_cidr = each.value["aws_subnet_cidr"]
 
}


module "aws__instances_us" {
  source = "./modules/aws-resources"
  providers         = { 
  aws = aws.us-east-1
  }
  for_each              = var.US_East_FrontEnd
  aws_region            = var.aws_region[1]
  aws_vpc_name          = each.value["aws_vpc_name"]
  aws_subnet_name       = each.value["aws_subnet_name"]
  rt_name               = each.value["rt_name"]
  igw_name              = each.value["igw_name"]
  private_ip            = each.value["private_ip"]
  tgw                   = "false"
  aws_ec2_name          = each.value["aws_ec2_name"]
  aws_ec2_key_pair_name = each.value["aws_ec2_key_pair_name"]

  aws_vpc_cidr    = each.value["aws_vpc_cidr"]
  aws_subnet_cidr = each.value["aws_subnet_cidr"]

}

# Create Linux and Networking Infrastructure in Azure

module "azure_instances_eu" {
  source = "./modules/azure-resources"
  providers = {
  azurerm = azurerm.eun
  }
  for_each             = var.North_EU_AppSvcs_VNets
  azure_resource_group = each.value["azure_resource_group"]
  azure_location       = "North Europe"
  azure_vnet_name      = each.value["azure_vnet_name"]
  azure_subnet_name    = each.value["azure_subnet_name"]
  azure_instance_name  = each.value["azure_instance_name"]
  azure_private_ip     = each.value["azure_private_ip"]
  azure_server_key_pair_name  = each.value["azure_server_key_pair_name"]
  azure_vm_size        = "Standard_DS1_v2"
  azure_admin_username = "linuxuser"
  azure_admin_password = "admin123"

  azure_subnet_cidr    = each.value["azure_subnet_cidr"]
  azure_vnet_cidr      = each.value["azure_vnet_cidr"]
}

# Onboard CSP Account into Prosimo Dashboard

resource "prosimo_cloud_creds" "aws" {
  cloud_type = "AWS"
  nickname   = "Prosimo_AWS"

  aws {
    preferred_auth = "AWSKEY"

    access_keys {
      access_key_id = var.Access_Key_AWS
      secret_key_id = var.Access_Secret_AWS
    }
  }
}

resource "prosimo_cloud_creds" "azure" {
  cloud_type = "AZURE"
  nickname   = "Prosimo_Azure"

  azure {
    subscription_id = var.subscription
    tenant_id       = var.tenantazure
    client_id       = var.client
    secret_id       = var.clientsecret
  }
}

# Create Prosimo Infra resources in AWS

/*
module "prosimo_resource_aws_eu" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = var.prosimo_cidr[0]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  multipleRegion = var.aws_region[0]
  wait = "false"

}
*/

module "prosimo_resource_aws_us" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = var.prosimo_cidr[1]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  multipleRegion = var.aws_region[1]
  wait = "false"

}

/*
module "prosimo_resource_aws" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  count      = length(var.prosimo_cidr)
  prosimo_cidr       = var.prosimo_cidr[count.index]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  bandwidth = "<1 Gbps"
  instance_type = "t3.medium"
  multipleRegion = var.aws_region[count.index]
  wait = "false"
  
}
*/

module "prosimo_resource_azure" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = "10.253.0.0/23"
  cloud = "AZURE"
  apply_node_size_settings = "true"
  cloud1 = "Prosimo_Azure"
  multipleRegion = "northeurope"
  wait = "false"
  
}

resource "aws_ec2_transit_gateway" "dev" {
provider = aws.us-east-1
description = "US-TGW"
tags = {
    Name = "US-TGW"
  }
}

/*
# Onboard Networks to Prosimo Fabric

module "network_eu" {
  source = "./modules/prosimo-network"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  name         = "WEB_Subnet_EU"
  region       = var.aws_region[0]
  subnets      = var.subnet_cidr[0]
  connectivity_type  = "vpc-peering"
  placement    = "Workload VPC"
  cloud        = "AWS"
  cloud_type   = "public"
  connectType  = "private"
  vpc          = module.aws__instances_eu.aws_vpc_id
  cloudNickname= "Prosimo"
  decommission = "false"
  onboard      = "true"
  depends_on   = [ module.prosimo_resource ] 
}



resource "aws_ec2_transit_gateway" "dev" {
provider = aws.eu-aws
description = "DEV"
tags = {
    Name = "DEV"
  }
}



# Create Virtual Instance and Networking Infrastructre in Azure
module "azure_instances_1" {
  source = "./modules/azure-resources"

  azure_resource_group = "demo_IaC_basic"
  azure_location       = "North Europe"
  azure_vnet_name      = "vnet_1"
  azure_subnet_name    = "subnet_1"
  azure_instance_name  = "vm_1"
  azure_vm_size        = "Standard_DS1_v2"
  azure_admin_username = "$test"
  azure_admin_password = "Test2022"

  azure_subnet_cidr = "10.0.0.0/16"
  azure_vnet_cidr   = "10.0.0.0/24"
}
*/
# Build MCN transit setup
resource "prosimo_visual_transit" "us-east" {
  transit_input {
    cloud_type   = "AWS"
    cloud_region = var.aws_region[1]

    transit_deployment {
      tgws {
        name   = aws_ec2_transit_gateway.dev.id
        action = "MOD"

        connection {
          type   = "EDGE"
          action = "ADD"
        }

        dynamic "connection" {
          for_each = var.US_East_FrontEnd

          content {
            type   = "VPC"
            action = "ADD"
            name   = connection.value.aws_vpc_name
          }
        }
      }
    }
  }

  deploy_transit_setup = true
  depends_on = [aws_ec2_transit_gateway.dev]
}


resource "prosimo_visual_transit" "eu_north"{
 transit_input {
    cloud_type   = "AZURE"
    cloud_region = "northeurope"
    transit_deployment {
        dynamic "vnets" {
		    for_each = var.North_EU_AppSvcs_VNets

            content {
  			action = "ADD"
  			name   = vnets.value.azure_vnet_name
            }
		}

    }
 }
 deploy_transit_setup = true

}