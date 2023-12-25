variable "prosimo_teamName" {
  type = string
}
variable "prosimo_token" {
  type = string
}
variable "cloud1" {
  type = string
}

variable "prosimo_cidr" {
  type = string
}

variable "cloud" {
  type = string
}

variable "multipleRegion" {
  type = string
}

variable "wait" {
  type = bool
}


variable "apply_node_size_settings" {
  type = string
  description = "Apply Node Size Settings if true..."
  default = false
}