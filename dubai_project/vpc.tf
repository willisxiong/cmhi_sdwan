resource "aws_vpc" "cmhi_vpc_1" {
    cidr_block = "10.1.0.0/16"

    tags = {
        Name = "cmhi_dubai_1"
    }
}

resource "aws_route_table" "sdwan_rt" {
  vpc_id = aws_vpc.cmhi_vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "sdwan_rt"
  }
}

resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.cmhi_vpc_1.id
    cidr_block = "10.1.1.0/24"

    tags = {
        Name = "pub_subnet"
    }
}

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.cmhi_vpc_1.id
    cidr_block = "10.1.2.0/24"

    tags = {
        Name = "pri_subnet"
    }
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.cmhi_vpc_1.id

  tags = {
    Name = "vgw_mpls"
  }
}

resource "aws_vpn_gateway_attachment" "vgw_attachment" {
  vpc_id = aws_vpc.cmhi_vpc_1.id
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cmhi_vpc_1.id

  tags = {
    Name = "igw-cmhi"
  }
}

resource "aws_eip" "eip_cmhi" {
  vpc = true
  network_interface = aws_network_interface.nic_public.id
  associate_with_private_ip = "10.1.2.1"
}