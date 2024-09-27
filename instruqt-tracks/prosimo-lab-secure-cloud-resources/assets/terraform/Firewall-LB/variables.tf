 
variable "rg" {
  type = string
  default = "Lab-Firewall-RG"
}


variable "location" {
  type = string 
  default = "North Europe"
}

variable subscription {
  type = string
  description = "azure subscription id"
}

variable client {
  type = string
  description = "azure client id"
}

variable clientsecret {
  type = string
  description = "azure client secret"
}

variable tenantazure {
  type = string
  description = "azure tenant id"
}