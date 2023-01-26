output "aws_instance_public_dns" {
  value = concat(aws_instance.quagga[*].public_dns, aws_instance.quagga1.public_dns)
}