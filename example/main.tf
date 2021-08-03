module "sgscanner" {
  source    = "git@github.com:muffat/sgscanner.git"

  iam_role_lambda = "arn:aws:iam::12345678:role/custom-lambda-role"
  function_name = "sgscanner"

  environment_variables = {
    SLACK_URL = "https://hooks.slack.com/services/.."
    SLACK_CHANNEL = "custom-slack-channel"
    SLACK_USERNAME = "slack-username"
  }
}

/*
Specify the provider
*/
provider "aws" {
  region = "ap-southeast-1"
}