variable "function_name" {
  description = "lambda function name"
  type        = string
  # default     = "dynamodb_stream_processor"
}

variable "role_arn" {
  description = "lambda function role arn"
  type        = string
}

variable "dynamodn_stream_arn" {
  description = "aws_dynamodb_table.items_table.stream_arn"
  type        = string
}

variable "sns_arn" {
  description = "sns topic arn"
  type        = string
}
