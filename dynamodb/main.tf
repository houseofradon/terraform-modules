locals {
  attribute = {
    default = "${list(map("name", var.hash_key, "type", var.hash_key_type))}"

    with_range_key = "${list(
      map("name", var.range_key, "type", var.range_key_type),
      map("name", var.hash_key, "type", var.hash_key_type)
    )}"
  }

  ttl = {
    default = []

    custom = [{
      enabled        = true
      attribute_name = "${var.ttl}"
    }]
  }
}

resource "aws_dynamodb_table" "table" {
  name           = "${var.table_name}"
  read_capacity  = "${var.min_read_capacity}"
  write_capacity = "${var.min_write_capacity}"
  hash_key       = "${var.hash_key}"
  range_key      = "${var.range_key == "0" ? "" : var.range_key}"

  server_side_encryption = {
    enabled = "${var.server_side_encryption}"
  }

  point_in_time_recovery = {
    enabled = "${var.point_in_time_recovery}"
  }

  ttl = "${local.ttl[var.ttl == "0" ? "default" : "custom"]}"

  attribute = "${local.attribute[var.range_key == "0" ? "default" : "with_range_key"]}"

  tags = "${var.tags}"
}

resource "aws_appautoscaling_target" "read_target" {
  min_capacity       = "${var.min_read_capacity}"
  max_capacity       = "${var.max_read_capacity == "0" ? var.min_read_capacity : var.max_read_capacity}"
  resource_id        = "table/${aws_dynamodb_table.table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write_target" {
  min_capacity       = "${var.min_write_capacity}"
  max_capacity       = "${var.max_write_capacity == "0" ? var.min_write_capacity : var.max_write_capacity}"
  resource_id        = "table/${aws_dynamodb_table.table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}
