resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "Medical_report_input_bucket" {
  bucket        = "${var.bucket_prefix}-${random_string.bucket_suffix.result}"
  force_destroy = true

  tags = {
    Name        = "${var.bucket_prefix}-${random_string.bucket_suffix.result}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "upload_bucket_versioning" {
  bucket = aws_s3_bucket.Medical_report_input_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload_bucket_encryption" {
  bucket = aws_s3_bucket.Medical_report_input_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "Medical_report_input_bucket_access" {
  bucket = aws_s3_bucket.Medical_report_input_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
