resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
locals {
  #environment_prefix = ${var.environment_name == "prod" ? "prd" : var.environment_name}
  environment_prefix = "${var.application_name}-${var.environment_name}"
  application_name   = "${var.application_name}-${random_string.suffix.result}"
  #   environment_name   = var.environment_name
}
