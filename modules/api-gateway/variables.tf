variable "lambda_invoke_arn" {
  description = "aws_lambda_function.file_upload_handler.invoke_arn"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "cognito user pool arn"
  type        = string
}
