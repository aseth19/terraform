

resource "aws_eks_cluster" "aws_eks" {
  name     = "eks_cluster_levelup"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_public_access = false
    subnet_ids             = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

  tags = {
    Name      = "EKS_Cluster_LevelUp"
    yor_trace = "f5ab9ba4-fa85-418a-8b6d-3eb61bd6ea4e"
  }
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "node_levelup"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = module.vpc.public_subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    yor_trace = "0bf2d011-0d2d-49fd-a7ca-f52c35d467a0"
  }
}