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


