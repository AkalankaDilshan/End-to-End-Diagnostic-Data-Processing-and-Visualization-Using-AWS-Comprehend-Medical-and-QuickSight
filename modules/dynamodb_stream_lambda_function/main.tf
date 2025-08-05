resource "aws_lambda_function" "dynamodb_processor" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = var.dynamodn_stream_arn
  function_name     = aws_lambda_function.dynamodb_processor.arn
  starting_position = "LATEST"
}

resource "aws_lambda_permission" "allow_dynamodb" {
  statement_id  = "AllowExecutionFromDynamoDB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb_processor.function_name
  principal     = "dynamodb.amazonaws.com"
  source_arn    = var.dynamodn_stream_arn
}


