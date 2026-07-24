

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
    Env       = "prod"
    yor_trace = "154d3542-da98-45dc-8444-93dc6da99cde"
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
    Env       = "prod"
    yor_trace = "fc78cc6d-6145-4c3d-bf02-c306ae581c19"
  }
}