provider "aws" {
  region = "eu-north-1"
}


module "iam_role_for_dynamodb_lambda" {
  source    = "./modules/Iam/iam_for_dynamodb_trigger"
  role_name = "dynamodb_lambda_iam_role"
}
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "Medical_report"
}

module "sns_trigger_lambda" {
  source        = "./modules/dynamodb_stream_lambda_function"
  function_name = "dynamodb_sns_function"
  role_arn      = module.iam_role_for_dynamodb_lambda.function_role_arn
  source_arn    = module.dynamodb.event_source_arn
}


