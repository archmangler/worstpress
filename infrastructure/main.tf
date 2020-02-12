//main infrastructure definition
resource "azurerm_resource_group" "worstpress" {
  name     = "${var.application_resource_group_name}"
  location = "${var.application_region}"

  tags = {
    environment = "${var.environment}"
    app         = "${var.appId}"
  }
}
