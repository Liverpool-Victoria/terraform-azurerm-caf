resource "azurerm_batch_certificate" "certificate" {
  account_name         = var.account_name
  resource_group_name  = var.resource_group_name
  certificate          = var.certificate
  format               = var.settings.format
  password             = try(var.settings.password, null)
  thumbprint           = var.settings.thumbprint
  thumbprint_algorithm = var.settings.thumbprint_algorithm
}
