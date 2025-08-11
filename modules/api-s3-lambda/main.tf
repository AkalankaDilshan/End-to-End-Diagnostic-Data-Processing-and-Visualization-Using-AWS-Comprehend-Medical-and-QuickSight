resource "aws_lambda_function" "file_upload_function" {
  function_name    = var.function_name
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket_id
    }
  }

  timeout     = 60
  memory_size = 256
}

# resource "aws_lambda_permission" "apligw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.file_upload_function.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${var.api_gateway_arn}/*/POST/upload"
# }
