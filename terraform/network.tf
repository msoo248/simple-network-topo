# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}

# SUBNET FOR ROUTING #

resource "aws_subnet" "subnet" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_subnet_cidr_block[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

resource "aws_network_interface" "eni_2" {
  vpc_zone_identifier    = [aws_subnet.subnet[0].id]
  subnet_id = aws_subnet.subnet[1].id
}

resource "aws_network_interface_attachment" "for_quagga2" {
    network_interface_id   = aws_network_interface.eni_2.id
    device_index           = 2
    instance_id            = aws_instance.quagga1.id
}


# SUBNET FOR PCS #

resource "aws_subnet" "subnet_pc" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_subnet_pc_cidr_block[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

resource "aws_network_interface" "eni_pc" {
  count                  = length(aws_subnet.subnet_pc)
  vpc_zone_identifier    = [aws_subnet.subnet[count.index].id]
  subnet_id              = aws_subnet.subnet_pc[count.index].id
}

resource "aws_network_interface_attachment" "for_pcs" {
  count                   = var.instance_count
  network_interface_id    = aws_network_interface.eni_pc[count.index].id
  device_index            = count.index
  instance_id             = aws_instance.quagga[count.index].id
}


# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnet" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ping
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
