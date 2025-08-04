variable "function_name" {
  description = "lambda function name"
  type        = string
  # default     = "dynamodb_stream_processor"
}

variable "role_arn" {
  description = "lambda function role arn"
  type        = string
}

variable "source_arn" {
  description = "trigger source arn"
  type        = string
}

