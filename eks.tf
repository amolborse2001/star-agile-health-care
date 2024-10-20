module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.15.1"

  cluster_name                      = local.eks_name
  cluster_endpoint_public_access    = true

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
    Name        = local.eks_name
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
