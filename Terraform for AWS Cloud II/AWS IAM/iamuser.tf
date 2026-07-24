#TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
  tags = {
    Env       = "prod"
    yor_trace = "4be3b752-f10c-48ea-ab69-471c390f2f57"
  }
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
  tags = {
    Env       = "prod"
    yor_trace = "ce17cabf-b661-46c9-9c08-e096de69cbcf"
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