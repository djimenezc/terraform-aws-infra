terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    workspace_key_prefix = "network-base"
    region               = "eu-west-1"
    dynamodb_table       = "terraform-locks"
    session_name         = "terraform"
    encrypt              = true
  }
  required_providers {
    aws = {
      source  = "aws"
      version = "4.25.0"
    }
  }
}

provider "aws" {
  assume_role {
    # This is a variable based on the AWS account
    role_arn     = var.jenkins_role_arn
    session_name = "terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = var.internet_gateway_name
  }
}

resource "aws_subnet" "web" {
  for_each = local.web_public_subnets_cidrs_per_availability_zone

  vpc_id                  = aws_vpc.main.id
  availability_zone_id    = each.value.id
  cidr_block              = each.value.subnet
  map_public_ip_on_launch = false

  tags = {
    "Name"                           = "public_web_${each.key}"
    "nexthink.com/subnet-visibility" = "public"
  }
}

resource "aws_subnet" "application" {
  for_each = local.application_private_subnets_cidrs_per_availability_zone

  vpc_id                  = aws_vpc.main.id
  availability_zone_id    = each.value.id
  cidr_block              = each.value.subnet
  map_public_ip_on_launch = false

  tags = {
    "Name"                           = "private_application_${each.key}"
    "nexthink.com/subnet-visibility" = "private"
  }
}

resource "aws_subnet" "database" {
  for_each = local.database_private_subnets_cidrs_per_availability_zone

  vpc_id                  = aws_vpc.main.id
  availability_zone_id    = each.value.id
  cidr_block              = each.value.subnet
  map_public_ip_on_launch = false

  tags = {
    "Name"                           = "private_database_${each.key}"
    "nexthink.com/subnet-visibility" = "private"
  }
}
