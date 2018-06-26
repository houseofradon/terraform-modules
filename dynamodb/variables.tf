variable "table_name" {}

variable "min_read_capacity" {
  default = 2
}

variable "max_read_capacity" {
  default = false
}

variable "min_write_capacity" {
  default = 2
}

variable "max_write_capacity" {
  default = false
}

variable "hash_key" {}

variable "hash_key_type" {
  default = "S"
}

variable "range_key" {
  default = false
}

variable "range_key_type" {
  default = "S"
}

variable "server_side_encryption" {
  default = true
}

variable "point_in_time_recovery" {
  default = true
}

variable "ttl" {
  default = false
}

variable "tags" {
  default = {
    Client = "Radon"
  }
}
