resource "aws_dynamodb_table" "medical_db" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "Report_ID"
  attribute {
    name = "Report_ID"
    type = "S"
  }
  attribute {
    name = "email"
    type = "S"
  }
}

# global_secondary_index {
#      name = "Patient_"
# }
