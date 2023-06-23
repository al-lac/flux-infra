terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "access" {
  type = string
}

variable "secret" {
  type = string
}

# Configure the AWS Provider
provider "aws" {
  region     = "eu-central-1"
  access_key = var.access
  secret_key = var.secret
}
