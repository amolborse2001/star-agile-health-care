locals {
  vpc_name                  = "your-vpc-name"  # Ensure this matches the eks_name if intended
  vpc_cidr                  = "10.0.0.0/16"     # Adjust CIDR block as needed
  vpc_availability_zones    = ["us-east-1a", "us-east-1b"]  # Availability zones
  vpc_public_subnets        = ["10.0.1.0/24"]   # Public subnet
  vpc_private_subnets       = ["10.0.2.0/24", "10.0.3.0/24"]   # Private subnets
  vpc_intra_subnets         = ["10.0.4.0/24", "10.0.5.0/24"]  # Intra subnets within CIDR

  vpc_tags = {  # Tags for VPC
    Name        = local.vpc_name
    Environment = "dev"  # Adjust as necessary
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name              = local.vpc_name
  cidr              = local.vpc_cidr
  azs               = local.vpc_availability_zones  # Reference to AZs
  public_subnets    = local.vpc_public_subnets      # Reference to public subnets
  private_subnets   = local.vpc_private_subnets     # Reference to private subnets
  intra_subnets     = local.vpc_intra_subnets       # Reference to intra subnets

  tags = local.vpc_tags  # Reference to tags
}
