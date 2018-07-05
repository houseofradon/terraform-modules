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
  role              = "${aws_iam_role.lambda_assume_role.arn}"
  handler           = "${var.handler}"
  runtime           = "${var.runtime}"
  timeout           = "${var.timeout}"
  memory_size       = "${var.memory}"

  tags = "${var.tags}"

  lifecycle {
    ignore_changes = ["last_modified"]
  }
}

resource "aws_lambda_permission" "permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.rest_api_id}/*/*/${var.endpoint_name}"
}

resource "aws_iam_role" "lambda_assume_role" {
  name = "${var.name}-lambda-assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
