provider "aws" {
  region = "us-east-1"
}

locals {
  eks_name = "my-eks-cluster"
  vpc_name  = "my-vpc"

  vpc_cidr         = "10.123.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  public_subnets   = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets  = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets    = ["10.123.5.0/24", "10.123.6.0/24"]

  tags = {
    Name = local.vpc_name
  }
}
