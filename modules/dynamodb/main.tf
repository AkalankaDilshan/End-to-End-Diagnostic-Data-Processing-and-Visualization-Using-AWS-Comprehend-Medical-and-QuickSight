resource "aws_dynamodb_table" "medical_reports" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"


  # Enable DynamoDB Stream
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE" # Can be NEW_IMAGE, OLD_IMAGE,

  hash_key = "Report_ID"
  attribute {
    name = "Report_ID"
    type = "S"
  }
}

# # Item 1
# resource "aws_dynamodb_table_item" "report_item_1" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1000" },
#     "Patient_Name" = { "S" = "Chris Brown" },
#     "Age"          = { "N" = "60" },
#     "Gender"       = { "S" = "Male" },
#     "Test_Name"    = { "S" = "ECG" },
#     "Result"       = { "S" = "Requires Follow-up" },
#     "Date"         = { "S" = "2025-02-04" },
#     "Doctor"       = { "S" = "Dr. Taylor" },
#     "Remarks"      = { "S" = "Lifestyle changes recommended" }
#   })
# }

# # Item 2
# resource "aws_dynamodb_table_item" "report_item_2" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1001" },
#     "Patient_Name" = { "S" = "James Thomas" },
#     "Age"          = { "N" = "63" },
#     "Gender"       = { "S" = "Female" },
#     "Test_Name"    = { "S" = "Kidney Function Test" },
#     "Result"       = { "S" = "Healthy" },
#     "Date"         = { "S" = "2025-05-14" },
#     "Doctor"       = { "S" = "Dr. Williams" },
#     "Remarks"      = { "S" = "Further tests advised" }
#   })
# }

# # Item 3
# resource "aws_dynamodb_table_item" "report_item_3" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1002" },
#     "Patient_Name" = { "S" = "Emily Davis" },
#     "Age"          = { "N" = "47" },
#     "Gender"       = { "S" = "Female" },
#     "Test_Name"    = { "S" = "ECG" },
#     "Result"       = { "S" = "Healthy" },
#     "Date"         = { "S" = "2025-07-14" },
#     "Doctor"       = { "S" = "Dr. Taylor" },
#     "Remarks"      = { "S" = "Further tests advised" }
#   })
# }

# # Item 4
# resource "aws_dynamodb_table_item" "report_item_4" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1003" },
#     "Patient_Name" = { "S" = "Sophia Anderson" },
#     "Age"          = { "N" = "45" },
#     "Gender"       = { "S" = "Female" },
#     "Test_Name"    = { "S" = "Blood Glucose" },
#     "Result"       = { "S" = "Healthy" },
#     "Date"         = { "S" = "2025-02-19" },
#     "Doctor"       = { "S" = "Dr. Taylor" },
#     "Remarks"      = { "S" = "No immediate concern" }
#   })
# }

# # Item 5
# resource "aws_dynamodb_table_item" "report_item_5" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1004" },
#     "Patient_Name" = { "S" = "James Thomas" },
#     "Age"          = { "N" = "25" },
#     "Gender"       = { "S" = "Male" },
#     "Test_Name"    = { "S" = "Lipid Profile" },
#     "Result"       = { "S" = "Slightly Elevated" },
#     "Date"         = { "S" = "2025-04-05" },
#     "Doctor"       = { "S" = "Dr. Brown" },
#     "Remarks"      = { "S" = "Further tests advised" }
#   })
# }

# # Item 6
# resource "aws_dynamodb_table_item" "report_item_6" {
#   table_name = aws_dynamodb_table.medical_reports.name
#   hash_key   = "Report_ID"

#   item = jsonencode({
#     "Report_ID"    = { "S" = "MR1005" },
#     "Patient_Name" = { "S" = "John Doe" },
#     "Age"          = { "N" = "56" },
#     "Gender"       = { "S" = "Female" },
#     "Test_Name"    = { "S" = "Blood Glucose" },
#     "Result"       = { "S" = "Normal" },
#     "Date"         = { "S" = "2025-03-05" },
#     "Doctor"       = { "S" = "Dr. Williams" },
#     "Remarks"      = { "S" = "Lifestyle changes recommended" }
#   })
# }

