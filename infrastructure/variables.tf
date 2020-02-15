//Variables and default

//24     node_count = "${var.node_machine_count}" //2
//25     vm_size    = "${var.node_machine_type}" //"Standard_D2_v2"

//The defaults specified below are really not adequate
//based on testing. Do consider bumping up the node type
//and possibly the count if you want H.A and capacity
variable "node_machine_count" {
  default = "1"
}

variable "node_machine_type" {
  default = "Standard_D2_v2"
}


variable "customerCode" {
  default = "acme"
}

variable "application_resource_group_name" {
 default = "worstpress-sea"
}

variable "application_region" {
  default = "southeastasia"
}

variable "environment" {
  default = "uat"
}

variable "appId" {
  default = "worstpress"
}

variable "client_id" {}
variable "client_secret" {}

locals {
  //this can be built up in more detail by convention
  aks_cluster_dns_prefix = "${var.appId}${var.environment}"
  aks_cluster_name       = "${var.customerCode}-${var.appId}-${var.environment}"
}

