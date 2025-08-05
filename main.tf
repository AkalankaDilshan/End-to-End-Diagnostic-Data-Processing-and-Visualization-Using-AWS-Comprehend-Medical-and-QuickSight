provider "aws" {
  region = "eu-north-1"
}


# module "iam_role_for_dynamodb_lambda" {
#   source    = "./modules/Iam/iam_for_dynamodb_trigger"
#   role_name = "dynamodb_lambda_iam_role"
# }

module "s3_bucket" {
  source        = "./modules/s3-bucket"
  aws_region    = "eu-north-1"
  bucket_prefix = "medical-reports-bucket"
  environment   = "development"
}
module "lambda_iam_role_s3_to_dynamodb" {
  source    = "./modules/iam/lambda_s3_dynamodb"
  role_name = "s3-to-dynamodb-lambda-role"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "Medical_report"
}
module "lambda_function_1" {
  source              = "./modules/s3-dynamodb-lambda"
  function_name       = "lambda_s3_to_dynamodb"
  dymamodb_table_name = module.dynamodb.dynamodb_table_name
  s3_bucket_arn       = module.s3_bucket.s3_bucket_arn
  role_arn            = module.lambda_iam_role_s3_to_dynamodb.lambda_role_arn
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "Medical_report"
}

# module "sns" {
#   source = "./modules/sns"
# }

# module "sns_trigger_lambda" {
#   source        = "./modules/dynamodb_stream_lambda_function"
#   function_name = "dynamodb_sns_function"
#   role_arn      = module.iam_role_for_dynamodb_lambda.function_role_arn
#   source_arn    = module.dynamodb.event_source_arn
#   depends_on    = [module.sns]
# }


