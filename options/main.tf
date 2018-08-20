resource "aws_api_gateway_method" "method" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${var.resource_id}"
  http_method          = "OPTIONS"
  authorization        = "${var.authorization}"
  api_key_required     = "${var.api_key_required}"
}

resource "aws_api_gateway_method_response" "response" {
  depends_on  = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "0"
    "method.response.header.Access-Control-Allow-Methods" = "0"
    "method.response.header.Access-Control-Allow-Origin"  = "0"
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "MOCK"
  uri                     = ""
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  credentials             = "${var.credentials}"
  request_templates       = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  depends_on  = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.response.status_code}"

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'${var.http_methods}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.origin}'"
  }
}
