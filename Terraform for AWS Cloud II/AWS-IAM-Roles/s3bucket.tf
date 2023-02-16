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


resource "aws_s3_bucket" "levelup-s3bucket_log_bucket" {
  bucket = "levelup-s3bucket-log-bucket"
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