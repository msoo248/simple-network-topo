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
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[count.index].id
  
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
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[0].id
  
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-2"
  })

}