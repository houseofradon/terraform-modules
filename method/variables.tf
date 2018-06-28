variable "rest_api_id" {}
variable "resource_id" {}
variable "http_method" {}

variable "authorization" {
  default = "NONE"
}

variable "api_key_required" {
  default = false
}

variable "request_validator_id" {}

variable "request_params" {
  default = {}
}

variable "request_model" {
  default = false
}

variable "response_model" {
  default = false
}

variable "integration_invoke_id" {}

variable "int_request_params" {
  default = {}
}

variable "request_template" {
  default = false
}

variable "response_template" {
  default = false
}

variable "error_model" {
  default = false
}

variable "passthrough_behavior" {
  default = "NEVER"
}

variable "credentials" {
  default = false
}

variable "integration_http_method" {
  default = "POST"
}

variable "404_selection_pattern" {
  default = ".*not-found.*"
}

variable "422_selection_pattern" {
  default = ".*:unprocessable-entity.*"
}

variable "500_selection_pattern" {
  default = ".*internal-server-error.*"
}
