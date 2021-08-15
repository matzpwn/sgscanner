/*
Define default IAM role & policy
*/

resource "aws_iam_role" "this" {
  count = var.role == null ? 1 : 0
  name  = "lambda-${var.function_name}"

  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role[0].json

  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  count  = var.role == null ? 1 : 0
  role   = aws_iam_role.this[0].name
  name   = "lambda-policy-${var.function_name}"
  policy = data.aws_iam_policy_document.ec2[0].json
}

data "aws_iam_policy_document" "lambda-assume-role" {
  count = var.role == null ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2" {
  count = var.role == null ? 1 : 0
  statement {
    actions = [
      "ec2:DescribeSecurityGroups"
    ]
    resources = ["*"]
  }
}