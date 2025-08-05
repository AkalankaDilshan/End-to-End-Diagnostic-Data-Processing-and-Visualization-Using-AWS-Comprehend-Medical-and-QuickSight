#Add pandas layer
data "aws_lambda_layer_version" "pandas" {
  layer_name = "AWSSDKPandas-Python311" # For Python 3.11
}

resource "aws_lambda_function" "file_processor_function" {
  function_name    = var.function_name
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  # Add layer
  layers = [data.aws_lambda_layer_version.pandas.arn]

  environment {
    variables = {
      #  DYNAMODB_TABLE_NAME = aws_dynamodb_table.data_table.name
      DYNAMODB_TABLE_NAME = var.dymamodb_table_name
      ALLOWED_EXTENSIONS  = join(",", var.allowed_file_extensions)
    }
  }

  timeout     = 60
  memory_size = 256
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.file_processor_function.arn
    events              = ["s3:ObjectCreated:*"]
    #     filter_prefix       = "uploads/"  # Optional: Only watch a specific prefix
    #     filter_suffix       = ".xlsx"     # Optional: Only watch for .xlsx files
  }

  #   depends_on = [aws_lambda_permission.allow_bucket]
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor_function.arn
  principal     = "s3.amazonaws.com"
  #source_arn    = aws_s3_bucket.upload_bucket.arn
  source_arn = var.s3_bucket_arn
}
