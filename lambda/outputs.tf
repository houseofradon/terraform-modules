output "invoke_arn" {
  value = "${aws_lambda_function.function.invoke_arn}"
}

output "arn" {
  value = "${aws_lambda_function.function.arn}"
}

output "assume_role_arn" {
  value = "${aws_iam_role.lambda_assume_role.arn}"
}

output "assume_role_name" {
  value = "${aws_iam_role.lambda_assume_role.name}"
}
