output "lambda_assume_role_arn" {
  value = "${aws_iam_role.lambda_assume_role.arn}"
}

output "lambda_assume_role_name" {
  value = "${aws_iam_role.lambda_assume_role.name}"
}
