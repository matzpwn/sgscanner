/*
Define default IAM role & policy
*/

resource "aws_iam_role" "this" {
  name = "lambda-${var.function_name}"

  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.this.name
  name   = "lambda-policy-${var.function_name}"
  policy = data.aws_iam_policy_document.ec2.json
}

data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    actions   = ["ec2:DescribeSecurityGroups"]
    resources = ["*"]
  }
}