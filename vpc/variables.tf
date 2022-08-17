variable "aws_region" {
  description = "Region where network base must be installed"
}

//It must be defined as TF_VAR_jenkins_role_arn
variable "jenkins_role_arn" {
  description = "Role for the automation to be able to deploy the resources"
  default     = ""
}

# Base networking variables
variable "cidr_block" {
  description = "Initial CIDR used for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name for the VPC"
  default     = "main"
}

variable "internet_gateway_name" {
  description = "Name for the Internet Gateway"
  default     = "main"
}

locals {
  availability_zones_ids   = slice(sort(data.aws_availability_zones.available.zone_ids), 0, 3)
  availability_zones_names = slice(sort(data.aws_availability_zones.available.names), 0, 3)

  web_cidr                 = cidrsubnet(var.cidr_block, 8, 0)
  web_public_subnet_cidrs = cidrsubnets(local.web_cidr, 2, 2, 2)
  web_public_subnets_cidrs_per_availability_zone = {
    for k, v in local.availability_zones_names :
    v => { name : v, id : local.availability_zones_ids[k], subnet : local.web_public_subnet_cidrs[k] }
  }

  application_cidr                 = cidrsubnet(var.cidr_block, 8, 1)
  application_private_subnet_cidrs = cidrsubnets(local.application_cidr, 2, 2, 2)
  application_private_subnets_cidrs_per_availability_zone = {
    for k, v in local.availability_zones_names :
    v => { name : v, id : local.availability_zones_ids[k], subnet : local.application_private_subnet_cidrs[k] }
  }

  database_cidr                 = cidrsubnet(var.cidr_block, 8, 2)
  database_private_subnet_cidrs = cidrsubnets(local.database_cidr, 2, 2, 2)
  database_private_subnets_cidrs_per_availability_zone = {
    for k, v in local.availability_zones_names :
    v => { name : v, id : local.availability_zones_ids[k], subnet : local.database_private_subnet_cidrs[k] }
  }

}
