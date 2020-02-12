provider "azurerm" {

  //whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"

  //https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html
//  subscription_id = ""
//  tenant_id = ""
//  client_id = ""
//  client_secret = ""
}

//bootstrap state storage
terraform {
    backend "azurerm" {}
}
