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
