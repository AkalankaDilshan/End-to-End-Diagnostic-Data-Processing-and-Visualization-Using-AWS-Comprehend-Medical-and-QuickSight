resource "aws_lambda_function" "file_processor_function" {
  function_name    = var.function_name
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  environment {
    variables = {
      #  DYNAMODB_TABLE_NAME = aws_dynamodb_table.data_table.name
      DYNAMODB_TABLE_NAME = var.dymamodb_table_name
      ALLOWED_EXTENSIONS  = join(",", var.allowed_file_extensions)
    }
  }
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.arn
  principal     = "s3.amazonaws.com"
  #source_arn    = aws_s3_bucket.upload_bucket.arn
  source_arn = var.s3_bucket_arn
}
