locals {
  vpc_name           = "your-vpc-name"  # Ensure this matches the eks_name if intended
  vpc_cidr           = "10.0.0.0/16"     # Adjust CIDR block as needed
  vpc_availability_zones = ["us-east-1a", "us-east-1b"]  # Change this name
  vpc_public_subnets     = ["10.0.1.0/24"]   # Change this name
  vpc_private_subnets    = ["10.0.2.0/24"]   # Change this name
  vpc_intra_subnets      = ["10.123.5.0/24", "10.123.6.0/24"]  # Change this name

  vpc_tags = {  # Change this name
    Name        = local.vpc_name
    Environment = "dev"  # Adjust as necessary
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name              = local.vpc_name
  cidr              = local.vpc_cidr
  azs               = local.vpc_availability_zones  # Change this reference
  public_subnets    = local.vpc_public_subnets     # Change this reference
  private_subnets   = local.vpc_private_subnets    # Change this reference
  intra_subnets     = local.vpc_intra_subnets      # Change this reference

  tags = local.vpc_tags  # Change this reference
}
