#Create AWS S3 Bucket

resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-141"
  acl    = "private"

  tags = {
    Name = "levelup-bucket-141"
  }
}


resource "aws_s3_bucket_versioning" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "destination" {
  bucket = aws_s3_bucket.levelup-s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication" {
  name = "aws-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_replication_configuration" "levelup-s3bucket" {
  depends_on = [aws_s3_bucket_versioning.levelup-s3bucket]
  role   = aws_iam_role.levelup-s3bucket.arn
  bucket = aws_s3_bucket.levelup-s3bucket.id
  rule {
    id = "foobar"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}




resource "aws_s3_bucket_server_side_encryption_configuration" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "levelup-s3bucket_log_bucket" {
  bucket = "levelup-s3bucket-log-bucket"
}


resource "aws_s3_bucket_versioning" "levelup-s3bucket_log_bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "destination" {
  bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication" {
  name = "aws-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_replication_configuration" "levelup-s3bucket_log_bucket" {
  depends_on = [aws_s3_bucket_versioning.levelup-s3bucket_log_bucket]
  role   = aws_iam_role.levelup-s3bucket_log_bucket.arn
  bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.id
  rule {
    id = "foobar"
    status = "Enabled"
    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}



resource "aws_s3_bucket_server_side_encryption_configuration" "levelup-s3bucket_log_bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_versioning" "levelup-s3bucket_log_bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.id

  target_bucket = aws_s3_bucket.levelup-s3bucket_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}