##################################################################################
# INSTANCES 
##################################################################################
resource "aws_instance" "quagga" {
  count                  = var.instance_count
  ami                    = "ami-076bdd070268f9b8d"
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
  ami                    = "ami-076bdd070268f9b8d"
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[0].id
  
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-quagga-2"
  })

}

##################################################################################
# TAGS
##################################################################################

resource "aws_tag" "green_tag" {
  count      = length(var.instance_ids)
  resource_id = var.instance_ids[count.index]
  key         = "State"
  value       = "BLUE"
}


