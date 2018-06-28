output "lambda_assume_role_arn" {
  value = "${aws_iam_role.lambda_assume_role.arn}"
}

output "lambda_assume_role_name" {
  value = "${aws_iam_role.lambda_assume_role.name}"
}

output "api_gateway_assume_role_arn" {
  value = "${aws_iam_role.api_gateway_assume_role.arn}"
}

output "api_gateway_assume_role_name" {
  value = "${aws_iam_role.api_gateway_assume_role.name}"
}
