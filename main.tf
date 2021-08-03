/*
Zip the code on the fly
*/
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "sgscanner.zip"
}

/*
Define lambda function
*/
resource "aws_lambda_function" "main" {
  function_name    = var.function_name
  description      = var.description
  filename         = "sgscanner.zip"
  role             = var.iam_role_lambda
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
    command = "rm -f sgscanner.zip"
  }

  depends_on = [
    aws_lambda_function.main
  ]
}