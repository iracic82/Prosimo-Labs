resource "prosimo_network_onboarding" "testapp-s3" {

    name = var.name
    public_cloud {
        cloud_type = var.cloud_type
        connection_option = var.connectType
        cloud_creds_name = var.cloudNickname
        region_name = var.region
        cloud_networks {
          vpc = var.vpc
          connector_placement = var.placement
          connectivity_type = var.connectivity_type
          subnets = [var.subnets]
          connector_settings {
            bandwidth = "small"
            bandwidth_name = "<1 Gbps"
            instance_type = "t3.medium"
          }
        }
       connect_type = "connector"
    }
    policies = ["ALLOW-ALL-NETWORKS"]
    onboard_app = var.onboard
    decommission_app = var.decommission
}
