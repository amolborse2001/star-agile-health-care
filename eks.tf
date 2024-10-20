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

# IAM Role for EKS
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
    Versi
