data "aws_iam_policy_document" "lambda_policy_doc" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:UpdateItem"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role" "lambda_role" {
  name = var.role_name
  assume_role_policy = jsondencode({
    version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principals = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Tag ad krnna methna
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.role_name}-lambda-policy"
  description = "IAM policy for Lambda to access logs, S3, and DynamoDB"
  policy      = data.aws_iam_policy_document.lambda_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
