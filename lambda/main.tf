data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket_object" "function_source" {
  bucket = "${var.s3_bucket}"
  key    = "${var.s3_key}"
}

resource "aws_lambda_function" "function" {
  s3_bucket         = "${data.aws_s3_bucket_object.function_source.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.function_source.key}"
  s3_object_version = "${data.aws_s3_bucket_object.function_source.version_id}"
  function_name     = "${var.function_name}"
  source_code_hash  = "${var.source_code_hash}"
  role              = "${var.role}"
  handler           = "${var.handler}"
  runtime           = "${var.runtime}"
  timeout           = "${var.timeout}"
  memory_size       = "${var.memory}"

  tags = "${var.tags}"
}

resource "aws_lambda_permission" "permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.rest_api_id}/*/*/${var.endpoint_name}"
}
