output "aws_quagga_public_dns" {
  value = concat(aws_instance.quagga[*].public_dns, [aws_instance.quagga2.public_dns])
}
output "aws_pc_public_dns" {
  value = aws_instance.PC[*].public_dns
}