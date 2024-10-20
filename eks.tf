locals {
  eks_name              = "your-eks-name"  # Ensure this matches the vpc_name if intended
  eks_cluster_version    = "1.21"           # Adjust as needed
  eks_node_group_name    = "your-node-group" # Change as necessary
  eks_subnet_ids        = module.vpc.private_subnets  # Use the VPC module's private subnets
  eks_tags = {
    Name        = local.eks_name
    Environment = "dev"  # Adjust as necessary
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "${local.eks_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Policy Attachment for EKS
resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "${local.eks_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"  # Correctly spelled
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # Ensure this is correct for node groups
        }
      },
    ]
  })
}

# Policy Attachment for Node Group
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Additional policy attachments for node role (optional)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registries_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = local.eks_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = local.eks_subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}

# EKS Node Group
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
