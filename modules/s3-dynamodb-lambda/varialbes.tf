variable "function_name" {
  description = "lambda function name"
  type        = string
  # default     = "dynamodb_stream_processor"
}

variable "role_arn" {
  description = "lambda function role arn"
  type        = string
}

variable "s3_bucket_arn" {
  description = "trigger source arn"
  type        = string
}

variable "dymamodb_table_name" {
  description = "table name for lambda "
  type        = string
}

variable "allowed_file_extensions" {
  description = "List of allowed file extensions"
  type        = list(string)
  default     = ["csv", "xlsx", "xls"]
}
