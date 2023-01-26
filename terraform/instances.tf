##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# INSTANCES 
##################################################################################
resource "aws_instance" "quagga" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet[count.index].id
  network_interface {
    network_interface_id = aws_network_interface.subnet_pc[count.index].id
  }
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-${count.index}"
  })

}

resource "aws_instance" "quagga1" {
  # count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet[0].id
  network_interface {
    network_interface_id = aws_network_interface.eni_2.id
  }
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-2"
  })

}