#TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
  tags = {
    yor_trace = "48d838d6-ca95-4cb6-9f3d-e2e72330754e"
  }
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
  tags = {
    yor_trace = "58d8518d-af7f-4840-8e4e-ddbc43398d7f"
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