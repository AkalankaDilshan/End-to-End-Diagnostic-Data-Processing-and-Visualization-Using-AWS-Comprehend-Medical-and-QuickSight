output "event_source_arn" {
  value = aws_dynamodb_table.medical_reports.stream_arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.medical_reports.name
}
