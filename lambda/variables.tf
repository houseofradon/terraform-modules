variable "s3_bucket" {
  default = "radon-bundles"
}

variable "prefix" {
  default = "default"
}

variable "s3_key" {}
variable "function_name" {}
variable "handler" {}

variable "source_code_hash" {
  default = ""
}

variable "runtime" {
  default = "java8"
}

variable "timeout" {
  default = "300"
}

variable "memory" {
  default = "512"
}

variable "tags" {
  default = {
    Client = "Radon"
  }
}

variable "rest_api_id" {}

variable "endpoint_name" {
  default = "*"
}

variable "stage" {
  default = false
}
