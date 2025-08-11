variable "function_name" {
  description = "name for lambda function"
  type        = string
  default     = "apiFileUploadHandler"
}


variable "role_arn" {
  description = "lambda iam role arn"
  type        = string
}

variable "s3_bucket_id" {
  description = "aws_s3_bucket.file_uploads.id"
  type        = string
}

# variable "api_gateway_arn" {
#   description = "aws_api_gateway_rest_api.file_upload_api.execution_arn"
#   type        = string
# }
