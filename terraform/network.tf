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
  availability_zone       = var.availability_zone
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

resource "aws_network_interface" "eni_2" {
  # availability_zone      = var.availability_zone
  subnet_id              = aws_subnet.subnet[1].id
  private_ip             = "10.0.2.2"
}

resource "aws_network_interface_attachment" "for_quagga2" {
  network_interface_id   = aws_network_interface.eni_2.id
  device_index           = 1
  instance_id            = aws_instance.quagga1.id
}


# SUBNET FOR PCS #

resource "aws_subnet" "subnet_pc" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_subnet_pc_cidr_block[count.index]
  availability_zone       = var.availability_zone
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

resource "aws_network_interface" "eni_pc" {
  # availability_zone      = var.availability_zone
  count                  = length(aws_subnet.subnet_pc)
  subnet_id              = aws_subnet.subnet_pc[count.index].id
  private_ip              = var.ip_list_pc[count.index]
}

resource "aws_network_interface_attachment" "for_pcs" {
  count                   = var.instance_count
  network_interface_id    = aws_network_interface.eni_pc[count.index].id
  device_index            = 1
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
