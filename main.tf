provider "aws" {
  region = "eu-north-1"
}

module "s3_bucket" {
  source        = "./modules/s3-bucket"
  aws_region    = "eu-north-1"
  bucket_prefix = "medical-reports-bucket"
  environment   = "development"
}
module "lambda_iam_role_s3_to_dynamodb" {
  source    = "./modules/Iam/iam_for_s3_db_lambda"
  role_name = "s3-to-dynamodb-lambda-role"
}

module "iam_role_for_dynamodb_lambda" {
  source    = "./modules/Iam/iam_for_dynamodb_trigger"
  role_name = "dynamodb_lambda_iam_role"
}

module "iam_role_for_api_s3_lambda" {
  source    = "./modules/Iam/iam_for_api_s3_lambda"
  role_name = "api_lambda_iam_role"
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
  s3_bucket_id        = module.s3_bucket.bucket_id
  role_arn            = module.lambda_iam_role_s3_to_dynamodb.lambda_role_arn
}

module "sns" {
  source = "./modules/sns"
}
module "sns_trigger_lambda" {
  source              = "./modules/dynamodb_stream_lambda_function"
  function_name       = "dynamodb_sns_function"
  role_arn            = module.iam_role_for_dynamodb_lambda.function_role_arn
  dynamodn_stream_arn = module.dynamodb.dynamodb_stream_arn
  sns_arn             = module.sns.sns_topic_arn
  depends_on          = [module.sns, module.iam_role_for_dynamodb_lambda]
}

module "apigateway" {
  source                = "./modules/api-gateway"
  cognito_user_pool_arn = "arn:aws:cognito-idp:eu-north-1:017117988836:userpool/eu-north-1_ExjMiZeM0"
  lambda_invoke_arn     = module.api_s3_lambda.lambda_function_arn
}
module "api_s3_lambda" {
  source          = "./modules/api-s3-lambda"
  role_arn        = module.iam_role_for_api_s3_lambda.lambda_role_arn
  s3_bucket_id    = module.s3_bucket.bucket_id
  api_gateway_arn = module.apigateway.api_gateway_arn
}

