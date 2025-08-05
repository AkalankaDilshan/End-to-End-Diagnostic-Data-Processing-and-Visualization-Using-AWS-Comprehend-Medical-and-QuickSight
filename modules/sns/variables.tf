variable "notification_name" {
  description = "Name for sns topic"
  type        = string
  default     = "medical_report_sns"
}

variable "notification_email_address" {
  description = "email address for SNS Subscribe"
  type        = string
  default     = "akalankadilshan98@gmail.com"
}
