# sgscanner

This module creates a Lambda function to scan Security group rules in AWS account and will notify users to Slack channel when detects non-compliant rule.

## Requirements

- Terraform ~> [v0.14.8](https://releases.hashicorp.com/terraform/0.14.8/)

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Lambda function name | `string` | `` | yes |
| description | Some descriptions | `string` | `` | no |
| environment_variables | Environment variables list to include the SLACK details. `SLACK_URL`, `SLACK_USERNAME`, and `SLACK_CHANNEL` | `map(string)` | `null` | yes |
| schedule_expression | Cloudwatch event custom cron expression | `string` | `cron(0 0 * * ? *)` | no |
| role | A custom IAM role arn | `string` | `null` | no |
| tags | A map of tags to add to lambda function | `map(string)` | `{}` | no |

## License
See the [LICENSE](LICENSE) file for license rights and limitations (MIT).