## Buy Me A [Coffee ☕️](https://www.buymeacoffee.com/devopsid)

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
  s3_bucket     = "bucket-name"

  environment_variables = {
    SLACK_URL      = "https://hooks.slack.com/.."
    SLACK_USERNAME = "test"
    SLACK_CHANNEL  = "slack-channel-name"
    TAG_EXCEPTION  = "tag-key,tag-value"
  }

  # Find the non-compliant IP address and port
  finder = {
    "0.0.0.0/0"   = [22, 443],
    "172.0.0.0/8" = 80
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
| s3_bucket | S3 bucket name to store the lambda object | `string` | `` | yes |
| environment_variables(`SLACK_URL`) | Environment variable for Slack URL webhook | `string` | `null` | no |
| environment_variables(`SLACK_USERNAME`) | Environment variable for Slack webhook username | `string` | `null` | no |
| environment_variables(`SLACK_CHANNEL`) | Environment variable for Slack webhook channel name | `string` | `null` | no |
| environment_variables(`TAG_EXCEPTION`) | Environment variable to whitelist the security group using specific tag. Format: `tag-key,tag-value` Example: `set-public,true` | `string` | `null` | no |
| schedule_expression | Cloudwatch event custom cron expression | `string` | `cron(0 0 * * ? *)` | no |
| role | A custom IAM role arn | `string` | `null` | no |
| finder | A map of IP address and port to find | `map(string)` | `{}` | no |
| tags | A map of tags to add to lambda function | `map(string)` | `{}` | no |

## License
See the [LICENSE](LICENSE) file for license rights and limitations (MIT).