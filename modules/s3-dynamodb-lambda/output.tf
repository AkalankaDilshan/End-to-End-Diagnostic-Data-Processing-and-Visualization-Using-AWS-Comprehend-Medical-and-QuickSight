output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.file_processor.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.file_processor.arn
}
