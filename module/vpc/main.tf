resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

provider "aws" {
    region = "us-east-1"
}


resource "aws_subnet" "public_A" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_A"
  }
}

resource "aws_subnet" "public_B" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public_B"
  }
}

resource "aws_subnet" "private_A" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_A"
  }
}

resource "aws_subnet" "private_B" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_B"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
 allocation_id = aws_eip.example.id
  subnet_id         = var.public_A_subnet
}

resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.example.id
  subnet_id         = var.public_B_subnet
}

resource "aws_eip" "example" {
domain = "vpc"
}

resource "aws_nat_gateway_eip_association" "example_A" {
  allocation_id  = aws_eip.example.id
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_nat_gateway_eip_association" "example_B" {
  allocation_id  = aws_eip.example.id
  nat_gateway_id = aws_nat_gateway.main2.id
}

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "internal_A" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table" "internal_B" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main2.id
  }
}