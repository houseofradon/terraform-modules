variable "rest_api_id" {}
variable "stage_name" {}
variable "subdomain" {}
variable "domain_name" {}
variable "usage_plan_name" {}
variable "usage_plan_desc" {}
variable "api_key_name" {}
variable "api_key_desc" {}
variable "certificate_arn" {
	default = "arn:aws:acm:us-east-1:875714392944:certificate/39cd11ae-1480-4cd8-9c7e-15580699201d"
}
