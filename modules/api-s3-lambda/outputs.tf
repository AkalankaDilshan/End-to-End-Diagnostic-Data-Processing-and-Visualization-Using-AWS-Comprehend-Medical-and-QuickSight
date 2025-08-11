output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.file_upload_function.arn
}

output "lambda_function_name" {
  description = "file_upload_function name"
  value       = aws_lambda_function.file_upload_function.function_name
}

output "lambda_invoke_arn" {
  description = "lambda function invoke arn"
  value       = aws_lambda_function.file_upload_function.invoke_arn
}
