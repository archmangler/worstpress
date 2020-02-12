//Variables and default

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

