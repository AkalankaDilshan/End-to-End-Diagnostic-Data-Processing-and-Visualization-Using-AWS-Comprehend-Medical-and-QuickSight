resource "aws_sns_topic" "notification" {
  name = var.notification_name
  #kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = var.notification_email_address
}
