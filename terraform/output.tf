output "aws_instance_public_dns" {
  value = aws_instance.quagga[*].public_dns
}