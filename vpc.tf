resource "aws_vpc" "bluerain_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "bluerain_vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.bluerain_vpc.id
  cidr_block = "10.10.10.0/24"

  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.bluerain_vpc.id
  cidr_block = "10.10.20.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.bluerain_vpc.id

  tags = {
    Name = "bluerain_vpc_IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.bluerain_vpc.id

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.bluerain_vpc.id
  cidr_block = "10.10.100.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.bluerain_vpc.id
  cidr_block = "10.10.200.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_eip" "nat_ip" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id

  subnet_id = aws_subnet.public_subnet1.id

  tags = {
    Name = "NAT_gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.bluerain_vpc.id

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_rt_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private_rt_nat" {
  route_table_id              = aws_route_table.private_rt.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway.id
}









