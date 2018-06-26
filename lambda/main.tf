data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "function" {
  s3_bucket        = "radon-bundles"
  s3_key           = "${var.s3_key}"
  function_name    = "${var.function_name}"
  source_code_hash = "${var.source_code_hash}"
  role             = "${var.role}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory}"

  tags = "${var.tags}"
}

resource "aws_lambda_permission" "permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.rest_api_id}/*/*/${var.endpoint_name}"
}
