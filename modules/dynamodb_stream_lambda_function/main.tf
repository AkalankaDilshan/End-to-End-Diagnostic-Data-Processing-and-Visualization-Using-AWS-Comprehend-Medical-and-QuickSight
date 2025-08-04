resource "aws_lambda_function" "dynamodb_trigger_lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")
}

resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = var.source_arn
  function_name     = aws_lambda_function.dynamodb_trigger_lambda.function_name
  starting_position = "LATEST"
}


