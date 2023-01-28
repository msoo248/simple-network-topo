##################################################################################
# INSTANCES 
##################################################################################
resource "aws_instance" "quagga" {
  count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[count.index].id
  private_ip             = var.ip_list[count.index]
  
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-${count.index}"
  })

}

resource "aws_instance" "quagga1" {
  # count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[0].id
  private_ip             = "10.0.1.20"
  
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-2"
  })

}
