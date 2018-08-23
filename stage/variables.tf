variable "rest_api_id" {}
variable "stage_name" {}
variable "subdomain" {}
variable "domain_name" {}
variable "usage_plan_name" {}
variable "usage_plan_desc" {}
variable "api_key_name" {}
variable "api_key_desc" {}
variable "certificate_arn" {
	default = false
}
variable "regional_certificate_arn" {
	default = false
}
variable "endpoint_type" {
	default = "EDGE"
}