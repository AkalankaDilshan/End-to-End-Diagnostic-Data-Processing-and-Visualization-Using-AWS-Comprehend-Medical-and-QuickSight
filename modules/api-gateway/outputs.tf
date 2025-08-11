output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.file_upload_api.execution_arn
}
