/*
Define cloudwatch event to trigger lambda
*/

resource "aws_cloudwatch_event_rule" "main" {
  name                = "sgscanner"
  description         = "Scan security group daily"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "main" {
  target_id = "sgscanner"
  arn       = aws_lambda_function.main.arn
  rule      = aws_cloudwatch_event_rule.main.name
}