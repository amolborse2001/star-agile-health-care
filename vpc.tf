locals {
  vpc_name           = "your-vpc-name"  # Replace with your desired VPC name
  vpc_cidr           = "10.0.0.0/16"     # Adjust CIDR block as needed
  availability_zones = ["us-east-1a", "us-east-1b"]  # Specify your desired availability zones
  public_subnets     = ["10.0.1.0/24"]   # Add your public subnet CIDR
  private_subnets    = ["10.0.2.0/24"]   # Add your private subnet CIDR
  intra_subnets      = []                 # Define intra-subnets if needed

  tags = {
    Name        = local.vpc_name
    Environment = "dev"  # Change as necessary
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
