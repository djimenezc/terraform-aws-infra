variable "aws_region" {
  description = "Region where network base must be installed"
}

//It must be defined as TF_VAR_jenkins_role_arn
variable "jenkins_role_arn" {
  description = "Role for the automation to be able to deploy the resources"
  default     = ""
}

# Non-toolkit related variables
# Base networking variables
variable "cidr_block" {
  description = "Initial CIDR used for the VPC"
  default     = ""
}

variable "vpc_name" {
  description = "Name for the VPC"
  default     = "main"
}
