variable "bucket_prefix" {
  description = "name for input s3 bucket"
  type        = string
}

variable "aws_region" {
  description = "region for s3 bucket"
  type        = string
}

variable "environment" {
  description = "for tags"
  type        = string
}

