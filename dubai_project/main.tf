provider "aws" {
  region = "ap-east-1"
}

resource "aws_instance" "sdwan_gw1" {
  ami                         = "ami-05a3ab9cebecfeadc"
  instance_type               = "c5.xlarge"
  key_name                    = "cmhi_sdwan"
  source_dest_check           = false
  subnet_id                   = aws_subnet.private1.id
  associate_public_ip_address = false
  availability_zone = "ap-east-1c"
}

resource "aws_ebs_volume" "data_vol" {
  availability_zone = "ap-east-1c"
  size = 20

  tags = {
    Name = "data volume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.data_vol.id
  instance_id = aws_instance.sdwan_gw1.id
}


resource "aws_network_interface" "nic_public" {
  subnet_id   = aws_subnet.public1.id
  private_ips = ["10.1.1.10"]
  security_groups = [aws_security_group.sdwan_sg.id]

  tags = {
    Name = "internet_access"
  }
}

resource "aws_network_interface_attachment" "internet" {
  instance_id          = aws_instance.sdwan_gw1.id
  network_interface_id = aws_network_interface.nic_public.id
  device_index         = 1
}

resource "aws_security_group" "sdwan_sg" {
  name        = "cmhi_sdwan_internet_sg"
  description = "allow internet traffic"
  vpc_id      = aws_vpc.cmhi_vpc_1.id

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ipsec"
    from_port = 500
    to_port = 500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ipsec"
    from_port = 4500
    to_port = 4500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}