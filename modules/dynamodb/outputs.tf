output "event_source_arn" {
  value = aws_dynamodb_table.users.stream_arn
}
