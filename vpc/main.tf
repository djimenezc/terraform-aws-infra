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
