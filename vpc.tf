locals {
  vpc_name           = "your-vpc-name"  # Ensure this matches the eks_name if intended
  vpc_cidr           = "10.0.0.0/16"     # Adjust CIDR block as needed
  availability_zones = ["us-east-1a", "us-east-1b"]  # Match with EKS availability zones
  public_subnets     = ["10.0.1.0/24"]   # Define your public subnet CIDR
  private_subnets    = ["10.0.2.0/24"]   # Define your private subnet CIDR
  intra_subnets      = ["10.123.5.0/24", "10.123.6.0/24"]  # Align with EKS intra subnets

  tags = {
    Name        = local.vpc_name
    Environment = "dev"  # Adjust as necessary
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.1"

  name              = local.vpc_name
  cidr              = local.vpc_cidr
  azs               = local.availability_zones
  public_subnets    = local.public_subnets
  private_subnets   = local.private_subnets
  intra_subnets     = local.intra_subnets

  tags = local.tags
}
