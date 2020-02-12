//define infrastructure outputs to be consumed by other processes
//this will print out kubeconf in the terraform output which may be a security risk ...

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.worstpress.kube_config.0.client_certificate}"
}

output "kube_config" {
    value ="${azurerm_kubernetes_cluster.worstpress.kube_config_raw}" 
}

