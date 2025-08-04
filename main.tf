provider "aws" {
  region = "eu-north-1"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "Medical_report"
}
