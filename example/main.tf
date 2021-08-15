/*
Example of using the module
*/
module "sgscanner" {
  source = "git@github.com:muffat/sgscanner.git"

  function_name = "sgscanner"
  description   = "This is an example"
  s3_bucket     = "<bucket-name>"

  environment_variables = {
    SLACK_URL      = "https://hooks.slack.com/.."
    SLACK_USERNAME = "test"
    SLACK_CHANNEL  = "slack-channel-name"
  }

  finder = {
    "0.0.0.0/0"   = [22, 443],
    "172.0.0.0/8" = 80
  }

  # If using the custom IAM role
  role = "<put-IAM-role-arn-here>"

  # If using the custom cron expression
  schedule_expression = "cron(0 0 * * ? *)"

  tags = {
    team = "my-team"
  }
}

/*
Specify the provider
*/
provider "aws" {
  region = "ap-southeast-1"
}