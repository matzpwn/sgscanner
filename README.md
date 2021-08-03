# sgscanner

This module creates a Lambda function to scan Security group rules in AWS account and will notify users to Slack channel when detects non-compliant rule.

## Pre-requisites

- Terraform ~> v0.14.8

## Usage

```tf
module "sgscanner" {
  source  = "git@github.com:muffat/sgscanner.git"

  function_name = "sgscanner"
  description   = "This is an example"

  environment_variables = {
    SLACK_URL = "https://hooks.slack.com/.."
    SLACK_USERNAME = "test"
    SLACK_CHANNEL = "production-issue"
  }

  tags = {
    team = "my-team"
  }
}
```

## License
See the [LICENSE](LICENSE) file for license rights and limitations (MIT).