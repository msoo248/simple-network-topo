locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
    Name         = var.machine_name
  }
  name_prefix    = "${var.naming_prefix}-dev"
}

