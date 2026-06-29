output "application_name" {
  value = var.application_name
}
output "environment_name" {
  value = var.environment_name
}
output "application_name_with_suffix" {
  value = local.application_name
}

output "suffix" {
  value = random_string.suffix.result
}