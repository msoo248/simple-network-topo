billing_code = "ACCT8675309"
project = "SoftwareEngineering"
machine_name = "Quagga"
name_prefix = "Quagga"
instance_ids = concat(aws_instance.quagga[*].public_dns, [aws_instance.quagga1.public_dns])