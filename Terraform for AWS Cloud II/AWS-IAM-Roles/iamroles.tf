#Roles to access the AWS S3 Bucket
resource "aws_iam_role" "s3-levelupbucket-role" {
  name               = "s3-levelupbucket-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    yor_trace = "655a0d58-cd8d-48ea-89c3-a85b7f123a83"
  }
}

#Policy to attach the S3 Bucket Role
resource "aws_iam_role_policy" "s3-levelupmybucket-role-policy" {
  name   = "s3-levelupmybucket-role-policy"
  role   = aws_iam_role.s3-levelupbucket-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::levelup-bucket-141",
              "arn:aws:s3:::levelup-bucket-141/*"
            ]
        }
    ]
}
EOF

}

#Instance identifier
resource "aws_iam_instance_profile" "s3-levelupbucket-role-instanceprofile" {
  name = "s3-levelupbucket-role"
  role = aws_iam_role.s3-levelupbucket-role.name
  tags = {
    yor_trace = "7f3a1215-31ad-4e4b-8aa6-8ce2b24e0f67"
  }
}