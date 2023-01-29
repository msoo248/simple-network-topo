locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
    Name         = var.machine_name
  }
  quagga_instance_names = ["${element(split(":" , aws_instance.quagga.*.tags["Name"]), 1)}"]
  PC_instance_names = ["${element(split(":" , aws_instance.PC.*.tags["Name"]), 1)}"]

}

