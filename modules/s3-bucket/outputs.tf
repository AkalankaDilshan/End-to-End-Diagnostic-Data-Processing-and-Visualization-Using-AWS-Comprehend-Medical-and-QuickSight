output "bucket_id" {
  value = aws_s3_bucket.Medical_report_input_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.Medical_report_input_bucket.arn
}
