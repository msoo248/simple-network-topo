##################################################################################
# INSTANCES 
##################################################################################
resource "aws_instance" "quagga" {
  count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[count.index].id
  source_dest_check      = false
  private_ip             = var.ip_list[count.index]
  
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "Quagga${count.index}"
  })

}

resource "aws_instance" "quagga2" {
  # count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[0].id
  source_dest_check      = false
  private_ip             = "10.0.1.20"
  
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "Quagga2"
  })

}

resource "aws_instance" "PC" {
  count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet_pc[count.index].id
  source_dest_check      = false
  private_ip             = var.ip_list_for_pcs[count.index]
  
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "PC${count.index}"
  })

}
