#TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
  tags = {
    Env       = "prod"
    yor_trace = "559300c5-c8ba-46b4-a9dd-8100c4799287"
  }
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
  tags = {
    Env       = "prod"
    yor_trace = "9b8b2ea3-b051-487d-8876-d9fbb6bde4c9"
  }
}

# Group TF Definition
resource "aws_iam_group" "admingroup" {
  name = "admingroup"
}

#Assign User to AWS Group
resource "aws_iam_group_membership" "admin-users" {
  name = "admin-users"
  users = [
    aws_iam_user.adminuser1.name,
    aws_iam_user.adminuser2.name,
  ]
  group = aws_iam_group.admingroup.name
}

#Policy for AWS Group
resource "aws_iam_policy_attachment" "admin-users-attach" {
  name       = "admin-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}