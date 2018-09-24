locals {
  request_template = {
    default = {}

    custom = {
      "application/json" = "${var.request_template}"
    }
  }

  response_template = {
    default = {}

    custom = {
      "application/json" = "${var.response_template}"
    }
  }

  request_model = {
    default = {}

    custom = {
      "application/json" = "${var.request_model}"
    }
  }

  response_model = {
    default = {}

    custom = {
      "application/json" = "${var.response_model}"
    }
  }

  error_model = {
    default = {}

    custom = {
      "application/json" = "${var.error_model}"
    }
  }

  response_parameters = {
    default = {}

    custom = {
      "method.response.header.Access-Control-Allow-Headers" = "0"
      "method.response.header.Access-Control-Allow-Methods" = "0"
      "method.response.header.Access-Control-Allow-Origin"  = "0"
    }
  }

  integration_response_parameters = {
    default = {}

    custom = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
      "method.response.header.Access-Control-Allow-Methods" = "'${var.http_method}'"
      "method.response.header.Access-Control-Allow-Origin"  = "'${var.origin}'"
    }
  }

  error_templates = {
    "application/json" = <<EOF
#set($errorResponse = $util.parseJson($input.path('$.errorMessage')))
{
  "message" : "$errorResponse.message"
} 
EOF
  }
}

resource "aws_api_gateway_method" "method" {
  rest_api_id          = "${var.rest_api_id}"
  resource_id          = "${var.resource_id}"
  http_method          = "${var.http_method}"
  authorization        = "${var.authorization}"
  authorizer_id        = "${var.authorizer_id}"
  api_key_required     = "${var.api_key_required}"
  request_validator_id = "${var.request_validator_id}"

  request_parameters = "${var.request_params}"

  request_models = "${local.request_model[var.request_model == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_method_response" "response_200" {
  depends_on  = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "200"

  response_models = "${local.response_model[var.response_model == "0" ? "default" : "custom"]}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "0"
    "method.response.header.Access-Control-Allow-Methods" = "0"
    "method.response.header.Access-Control-Allow-Origin"  = "0"
  }
}

resource "aws_api_gateway_method_response" "response_404" {
  depends_on  = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "404"

  response_models = "${local.error_model[var.error_model == "0" ? "default" : "custom"]}"

  response_parameters = "${local.response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_method_response" "response_422" {
  depends_on  = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "422"

  response_models = "${local.error_model[var.error_model == "0" ? "default" : "custom"]}"

  response_parameters = "${local.response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_method_response" "response_500" {
  depends_on  = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "500"

  response_models = "${local.error_model[var.error_model == "0" ? "default" : "custom"]}"

  response_parameters = "${local.response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_method}"
  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.integration_invoke_id}"
  passthrough_behavior    = "${var.passthrough_behavior}"
  credentials             = "${var.credentials}"

  request_parameters = "${var.int_request_params}"
  request_templates  = "${local.request_template[var.request_template == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  depends_on  = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "${aws_api_gateway_method_response.response_200.status_code}"

  response_templates = "${local.response_template[var.response_template == "0" ? "default" : "custom"]}"

  response_parameters = "${local.integration_response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_integration_response" "integration_response_404" {
  depends_on         = ["aws_api_gateway_integration.integration"]
  rest_api_id        = "${var.rest_api_id}"
  resource_id        = "${var.resource_id}"
  http_method        = "${var.http_method}"
  status_code        = "${aws_api_gateway_method_response.response_404.status_code}"
  selection_pattern  = "${var.selection_pattern_404}"
  response_templates = "${local.error_templates}"

  response_parameters = "${local.integration_response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_integration_response" "integration_response_422" {
  depends_on         = ["aws_api_gateway_integration.integration"]
  rest_api_id        = "${var.rest_api_id}"
  resource_id        = "${var.resource_id}"
  http_method        = "${var.http_method}"
  status_code        = "${aws_api_gateway_method_response.response_422.status_code}"
  selection_pattern  = "${var.selection_pattern_422}"
  response_templates = "${local.error_templates}"

  response_parameters = "${local.integration_response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}

resource "aws_api_gateway_integration_response" "integration_response_500" {
  depends_on         = ["aws_api_gateway_integration.integration"]
  rest_api_id        = "${var.rest_api_id}"
  resource_id        = "${var.resource_id}"
  http_method        = "${var.http_method}"
  status_code        = "${aws_api_gateway_method_response.response_500.status_code}"
  selection_pattern  = "${var.selection_pattern_500}"
  response_templates = "${local.error_templates}"

  response_parameters = "${local.integration_response_parameters[var.access_control_allow == "0" ? "default" : "custom"]}"
}
