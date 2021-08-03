module "sgscanner" {
  source = "git@github.com:muffat/sgscanner.git"

  function_name = "sgscanner"
  description   = "This is an example"

  environment_variables = {
    SLACK_URL      = "https://hooks.slack.com/.."
    SLACK_USERNAME = "test"
    SLACK_CHANNEL  = "production-issue"
  }

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