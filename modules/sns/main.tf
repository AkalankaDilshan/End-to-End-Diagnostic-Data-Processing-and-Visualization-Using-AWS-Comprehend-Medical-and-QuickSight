resource "aws_sns_topic" "database_update" {
  name              = var.topic_name
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.database_update.arn
  protocol  = "email"
  endpoint  = var.email_address
}
