terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # You can specify the version range you want
    }
  }

  required_version = ">= 1.0"  # Ensure Terraform version is 1.0 or higher
}

provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}
