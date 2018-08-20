variable "rest_api_id" {}
variable "resource_id" {}
variable "origin" {
  default = "*"
}

variable "http_methods" {
  default = "HEAD,GET,POST,PUT,OPTIONS,PATCH"
}

variable "authorization" {
  default = "NONE"
}

variable "api_key_required" {
  default = false
}

variable "credentials" {
  default = ""
}
