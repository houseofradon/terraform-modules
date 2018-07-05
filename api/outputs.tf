output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.api.id}"
}

output "root_resource_id" {
  value = "${aws_api_gateway_rest_api.api.root_resource_id}"
}

output "none_validator" {
  value = "${aws_api_gateway_request_validator.none.id}"
}

output "only_body_validator" {
  value = "${aws_api_gateway_request_validator.only_body.id}"
}

output "only_params_validator" {
  value = "${aws_api_gateway_request_validator.only_params.id}"
}

output "full_validator" {
  value = "${aws_api_gateway_request_validator.full.id}"
}

output "assume_role_arn" {
  value = "${aws_iam_role.api_gateway_assume_role.arn}"
}

output "assume_role_name" {
  value = "${aws_iam_role.api_gateway_assume_role.name}"
}
