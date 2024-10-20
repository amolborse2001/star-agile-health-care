locals {
  **eks_name**          = "your-eks-name"  # Ensure this matches the vpc_name if intended
  **eks_cluster_version** = "1.21"          # Adjust as needed
  **eks_node_group_name** = "your-node-group" # Change as necessary
  **eks_subnet_ids**    = module.vpc.private_subnets  # Use the VPC module's private subnets
  **eks_tags** = {
    Name        = local.eks_name
    Environment = "dev"  # Adjust as necessary
  }
}

resource "aws_eks_cluster" "this" {
  name     = local.eks_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = local.eks_subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = local.eks_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.this]
}
