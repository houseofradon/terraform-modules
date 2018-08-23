resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "${var.usage_plan_name}"
  description = "${var.usage_plan_desc}"

  api_stages {
    api_id = "${var.rest_api_id}"
    stage  = "${aws_api_gateway_deployment.deployment.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name        = "${var.api_key_name}"
  description = "${var.api_key_desc}."
}

resource "aws_api_gateway_usage_plan_key" "plan_key" {
  key_id        = "${aws_api_gateway_api_key.api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.usage_plan.id}"
}

resource "aws_api_gateway_domain_name" "edge_subdomain" {
  count = "${var.endpoint_type == "EDGE" ? 1 : 0}"

  domain_name     = "${var.subdomain}.${var.domain_name}"
  certificate_arn = "${var.certificate_arn}"

  endpoint_configuration = {
    types = ["${var.endpoint_type}"]
  }
}

resource "aws_api_gateway_domain_name" "regional_subdomain" {
  count = "${var.endpoint_type == "REGIONAL" ? 1 : 0}"

  domain_name              = "${var.subdomain}.${var.domain_name}"
  regional_certificate_arn = "${var.regional_certificate_arn}"

  endpoint_configuration = {
    types = ["${var.endpoint_type}"]
  }
}

data "aws_route53_zone" "domain" {
  name = "${var.domain_name}."
}

resource "aws_api_gateway_base_path_mapping" "edge_base_path" {
  count = "${var.endpoint_type == "EDGE" ? 1 : 0}"

  api_id      = "${var.rest_api_id}"
  stage_name  = "${aws_api_gateway_deployment.deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.edge_subdomain.domain_name}"
  base_path   = ""
}

resource "aws_api_gateway_base_path_mapping" "regional_base_path" {
  count = "${var.endpoint_type == "REGIONAL" ? 1 : 0}"

  api_id      = "${var.rest_api_id}"
  stage_name  = "${aws_api_gateway_deployment.deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.regional_subdomain.domain_name}"
  base_path   = ""
}

resource "aws_route53_record" "edge_domain_record" {
  count = "${var.endpoint_type == "EDGE" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.domain.id}"
  name    = "${aws_api_gateway_domain_name.edge_subdomain.domain_name}"
  type    = "A"

  alias = {
    name                   = "${aws_api_gateway_domain_name.edge_subdomain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.edge_subdomain.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "regional_domain_record" {
  count = "${var.endpoint_type == "REGIONAL" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.domain.id}"
  name    = "${aws_api_gateway_domain_name.regional_subdomain.domain_name}"
  type    = "A"

  alias = {
    name                   = "${aws_api_gateway_domain_name.regional_subdomain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.regional_subdomain.regional_zone_id}"
    evaluate_target_health = true
  }
}
