resource "aws_iam_policy" "logging_policy" {
  name        = "${var.name}-logging-policy"
  path        = "/"
  description = "IAM policy for logging from api gateway and lambda for ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
         "logs:CreateLogGroup",
         "logs:CreateLogStream",
         "logs:DescribeLogGroups",
         "logs:DescribeLogStreams",
         "logs:PutLogEvents",
         "logs:GetLogEvents",
         "logs:FilterLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
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

resource "aws_iam_role" "api_gateway_assume_role" {
  name = "${var.name}-api-gateway-assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.lambda_assume_role.name}"
  policy_arn = "${aws_iam_policy.logging_policy.arn}"
}
