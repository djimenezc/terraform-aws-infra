output "web_private_subnets_cidrs_per_availability_zone" {
  value = local.web_private_subnets_cidrs_per_availability_zone
}

output "application_private_subnets_cidrs_per_availability_zone" {
  value = local.application_private_subnets_cidrs_per_availability_zone
}

output "database_private_subnets_cidrs_per_availability_zone" {
  value = local.database_private_subnets_cidrs_per_availability_zone
}
