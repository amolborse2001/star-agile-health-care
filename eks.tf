provider "aws" {
  region = "us-east-1"
}

locals {
  name = "my-eks-cluster"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = local.name
  cidr = "10.123.0.0/16"

  azs              = ["us-east-1a", "us-east-1b"]
  public_subnets   = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets  = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets    = ["10.123.5.0/24", "10.123.6.0/24"]

  tags = {
    Name = local.name
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.15.1"

  cluster_name    = local.name
  cluster_endpoint_public_access = true
  
  cluster_addons = {
    coredns = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update  = "OVERWRITE"
    }
    kube_proxy = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update  = "OVERWRITE"
    }
    vpc_cni = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update  = "OVERWRITE"
    }
  }

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.public_subnets
  control_plane_subnet_ids        = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types = ["m5.large"]
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    "amc-cluster-wg" = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Name = local.name
    Environment = "dev"
  }
}

output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_groups" {
  value = module.eks.node_groups
}
