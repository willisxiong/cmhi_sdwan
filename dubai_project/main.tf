provider "aws" {
    region = "ap-east-1"
}

resource "aws_instance" "sdwan_gw1" {
  instance_type = "c5.xlarge"
}

resource "aws_network_interface" "nic_public" {
  subnet_id = aws_subnet.public1.id
  private_ips = ["10.1.1.1"]

  tags = {
    Name = "internet_access"
  }
}

resource "aws_network_interface" "nic_private" {
  subnet_id = aws_subnet.private1.id
  private_ips = ["10.1.2.1"]

  tags = {
    Name = "mpls_access"
  }
}