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
    yor_trace = "8f5b73e5-969a-44f2-918b-ee70e73772bb"
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
    yor_trace = "cd533b52-1e65-41f0-966f-46047003836d"
  }
}