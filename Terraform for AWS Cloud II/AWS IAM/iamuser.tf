#TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
  tags = {
    yor_trace = "a8a5711a-7bb1-4b25-ba47-93930dd529a1"
  }
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
  tags = {
    yor_trace = "485c533c-90ce-4c71-bc67-aa521c6f85c9"
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