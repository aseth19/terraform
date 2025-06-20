#Create AWS S3 Bucket

resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-141"
  acl    = "private"

  tags = {
    Name      = "levelup-bucket-141"
    Env       = "prod"
    yor_trace = "89bb54b6-57db-4de7-9a25-9ecbd14aaa32"
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
  tags = {
    Env       = "prod"
    yor_trace = "fb2b1b28-e803-409c-929a-9fab8c229735"
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
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "levelup-s3bucket" {
  bucket = aws_s3_bucket.levelup-s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}