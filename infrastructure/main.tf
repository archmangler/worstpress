//main infrastructure definition
resource "azurerm_resource_group" "worstpress" {
  name     = "${var.application_resource_group_name}"
  location = "${var.application_region}"

  tags = {
    environment = "${var.environment}"
    app         = "${var.appId}"
  }
}

//AKS cluster needs a Service Principal (get client_id and client_secret)

//primary aks cluster with default nodepool
resource "azurerm_kubernetes_cluster" "worstpress" {
  name                = "${local.aks_cluster_name}"
  location            = "${azurerm_resource_group.worstpress.location}"
  resource_group_name = "${azurerm_resource_group.worstpress.name}"
  dns_prefix          = "${local.aks_cluster_dns_prefix}"

  //we could variablise better here
  default_node_pool {
    name       = "default"
    node_count = "${var.node_machine_count}" //2
    vm_size    = "${var.node_machine_type}" //"Standard_D2_v2"
  }

  service_principal {
    client_id     = "${var.client_id}"     //"00000000-0000-0000-0000-000000000000"
    client_secret = "${var.client_secret}" //"00000000000000000000000000000000"
  }

  tags = {
    environment = "${var.environment}"
    app         = "${var.appId}"
  }
}
