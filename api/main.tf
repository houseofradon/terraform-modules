resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api_name}"
  description = "${var.api_description}"
}

resource "aws_api_gateway_request_validator" "full" {
  name                        = "full"
  rest_api_id                 = "${aws_api_gateway_rest_api.api.id}"
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_request_validator" "only_body" {
  name                        = "only-body"
  rest_api_id                 = "${aws_api_gateway_rest_api.api.id}"
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_request_validator" "only_params" {
  name                        = "only-params"
  rest_api_id                 = "${aws_api_gateway_rest_api.api.id}"
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_request_validator" "none" {
  name                        = "none"
  rest_api_id                 = "${aws_api_gateway_rest_api.api.id}"
  validate_request_body       = false
  validate_request_parameters = false
}

resource "aws_api_gateway_gateway_response" "invalid_parameters" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  status_code   = "400"
  response_type = "BAD_REQUEST_PARAMETERS"

  response_templates = {
    "application/json" = <<EOF
{
  "message": $context.error.messageString,
  "error": "$context.error.validationErrorString"
}
EOF
  }
}

resource "aws_api_gateway_gateway_response" "invalid_body" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  status_code   = "400"
  response_type = "BAD_REQUEST_BODY"

  response_templates = {
    "application/json" = <<EOF
{
  "message": $context.error.messageString,
  "error": "$context.error.validationErrorString"
}
EOF
  }
}
