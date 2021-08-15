/*
Write the Security group rules
*/
resource "null_resource" "config" {
  provisioner "local-exec" {
    command = "echo '${jsonencode(var.finder)}' > ${path.module}/src/sg.config"
  }

  triggers = {
    config_contents = jsonencode(var.finder)
  }
}

/*
Zip the code
*/
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/sgscanner.zip"

  depends_on = [
    null_resource.config
  ]
}

/*
Upload to s3
*/
resource "aws_s3_bucket_object" "this" {
  bucket = var.s3_bucket
  key    = "sgscanner.zip"
  source = data.archive_file.source.output_path
}

/*
Define lambda function
*/
resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  description      = var.description
  s3_bucket        = var.s3_bucket
  s3_key           = aws_s3_bucket_object.this.key
  role             = var.role != null ? var.role : aws_iam_role.this[0].arn
  handler          = "sgscanner.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.source.output_base64sha256
  tags             = var.tags

  dynamic "environment" {
    for_each = var.environment_variables != null ? [{ variables = var.environment_variables }] : []

    content {
      variables = environment.value.variables
    }
  }

  depends_on = [
    data.archive_file.source
  ]
}

/*
Clean up local path
*/
resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "rm -f ${path.module}/sgscanner.zip"
  }

  triggers = {
    config_contents = aws_lambda_function.main.source_code_hash
  }

  depends_on = [
    aws_lambda_function.main
  ]
}