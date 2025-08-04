variable "topic_name" {
  description = "Name for sns topic"
  type        = string
  default     = "medical_report_sns"
}

variable "email_address" {
  description = "email address for SNS Subscribe"
  type        = string
  default     = "akalankadilshan98@gmail.com"
}
