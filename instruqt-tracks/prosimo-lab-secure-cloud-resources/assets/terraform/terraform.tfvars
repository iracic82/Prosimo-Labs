aws_region = [
          "eu-west-1",
          "us-east-1",
]

vpc_cidr = [ 
          "10.0.0.0/16",
          "10.1.0.0/16", 
]

subnet_cidr = [ 
          "10.0.0.0/24",
          "10.1.0.0/24",
 ]

prosimo_cidr = [
          "10.251.0.0/23",
          "10.252.0.0/23",
]

private_ip = [
          "10.0.0.100",
          "10.1.0.100",
]

cloud_type = "AWS"


US_East_FrontEnd = {
  VPC1 = {
    aws_vpc_name          = "WebSvcsProdUs"
    igw_name              = "WebSvcsProdUs-IGW"
    rt_name               = "WebSvcsProdUs-RT"
    aws_subnet_name       = "WebSvcsProdUs-subnet"
    private_ip            = "10.2.0.100"
    aws_ec2_name          = "WebServerProdUs1"
    aws_ec2_key_pair_name = "US_EAST_WebSvcsProd"
    aws_vpc_cidr          = "10.2.0.0/16"
    aws_subnet_cidr       = "10.2.0.0/24"
  },

  VPC2 = {
    aws_vpc_name          = "WebSvcsDevUs"
    igw_name              = "WebSvcsDevUs-IGW"
    rt_name               = "WebSvcsDevUs-RT"
    aws_subnet_name       = "WebSvcsDevUs-subnet"
    private_ip            = "10.3.0.100"
    aws_ec2_name          = "WebServerDevUs1"
    aws_ec2_key_pair_name = "US_EAST_WebSvcsDev"
    aws_vpc_cidr          = "10.3.0.0/16"
    aws_subnet_cidr       = "10.3.0.0/24"
  }
}

EU_West_FrontEnd = {
  VPC1 = {
    aws_vpc_name          = "WebSvcsProdEu"
    igw_name              = "WebSvcsProdEu-IGW"
    rt_name               = "WebSvcsProdEu-RT"
    aws_subnet_name       = "WebSvcsProdEu-Subnet"
    private_ip            = "10.4.0.100"
    aws_ec2_name          = "WebServerProdEu1"
    aws_ec2_key_pair_name = "EU_WEST_WebSvcsProd"
    aws_vpc_cidr          = "10.4.0.0/16"
    aws_subnet_cidr       = "10.4.0.0/24"
  },

  VPC2 = {
    aws_vpc_name          = "WebSvcsDevEu"
    igw_name              = "WebSvcsDevEu-IGW"
    rt_name               = "WebSvcsDevEu-RT"
    aws_subnet_name       = "WebSvcsDevEu-Subnet"
    private_ip            = "10.5.0.100"
    aws_ec2_name          = "WebServerDevEu1"
    aws_ec2_key_pair_name = "EU_WEST_WebSvcsDev"
    aws_vpc_cidr          = "10.5.0.0/16"
    aws_subnet_cidr       = "10.5.0.0/24"
  }
}

North_EU_AppSvcs_VNets = {
  Vnet1 = {
    azure_resource_group        = "AppSvcsProdEu"
    azure_location              = "North Europe"
    azure_vnet_name             = "AppSvcsProdEu_Vnet"
    azure_subnet_name           = "AppSvcsProdEu_Vnet_subnet"
    azure_instance_name         = "AppSvcsProdEu"
    azure_vm_size               = "Standard_DS1_v2"
    azure_server_key_pair_name  = "Azure_Srv1"
    azure_admin_username        = "igorlinux"
    azure_admin_password        = "igorlinux"
    azure_subnet_cidr           = "10.0.0.0/24"
    azure_vnet_cidr             = "10.0.0.0/16"
    azure_private_ip            = "10.0.0.100"
  },

  Vnet2 = {
    azure_resource_group        = "AppSvcsDevEu"
    azure_location              = "North Europe"
    azure_vnet_name             = "AppSvcsDevEu_Vnet"
    azure_subnet_name           = "AppSvcsDevEu_Vnet_subnet"
    azure_instance_name         = "AppSvcsDevEu"
    azure_vm_size               = "Standard_DS1_v2"
    azure_server_key_pair_name  = "Azure_Srv2"
    azure_admin_username        = "igorlinux"
    azure_admin_password        = "igorlinux"
    azure_subnet_cidr           = "10.1.0.0/24"
    azure_vnet_cidr             = "10.1.0.0/16"
    azure_private_ip            = "10.1.0.100"
  }
}
