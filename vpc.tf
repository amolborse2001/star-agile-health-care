locals {
  name             = "my-vpc"
  vpc_cidr         = "10.123.0.0/16"
  azs              = ["us-east-1a", "us-east-1b"]
  private_subnets  = ["10.123.3.0/24", "10.123.4.0/24"]
  public_subnets   = ["10.123.1.0/24", "10.123.2.0/24"]
  intra_subnets    = ["10.123.5.0/24", "10.123.6.0/24"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name                  = local.name
  cidr                  = local.vpc_cidr
  azs                   = local.azs
  private_subnets       = local.private_subnets
  public_subnets        = local.public_subnets
  intra_subnets         = local.intra_subnets
  enable_nat_gateway     = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Name        = local.name
    Environment = "dev"
  }
}
