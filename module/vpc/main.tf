resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

    enable_dns_support   = true
  enable_dns_hostnames = true
}

provider "aws" {
    region = "us-east-1"
}


resource "aws_subnet" "public_A" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_A"
  }
}

resource "aws_subnet" "public_B" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

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



resource "aws_nat_gateway" "main" {
 allocation_id = aws_eip.main.id
  subnet_id         = aws_subnet.public_A.id
   depends_on = [aws_internet_gateway.igw]
   
}



resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.main2.id
  subnet_id         = aws_subnet.public_B.id
   depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "main" {
domain = "vpc"
 
}

resource "aws_eip" "main2" {
domain = "vpc"
 
}

resource "aws_route_table_association" "public_A_assoc" {
  subnet_id      = aws_subnet.public_A.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table_association" "public_B_assoc" {
  subnet_id      = aws_subnet.public_B.id
  route_table_id = aws_route_table.external.id
}

# resource "aws_nat_gateway_eip_association" "example_A" {
#   allocation_id  = aws_eip.example.id
#   nat_gateway_id = aws_nat_gateway.main.id
# }

resource "aws_route_table_association" "private_A_assoc" {
  subnet_id      = aws_subnet.private_A.id
  route_table_id = aws_route_table.internal_A.id
}

resource "aws_route_table_association" "private_B_assoc" {
  subnet_id      = aws_subnet.private_B.id
  route_table_id = aws_route_table.internal_B.id
  depends_on = [aws_route_table.internal_B]
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
  depends_on = [aws_nat_gateway.main]
}

resource "aws_route_table" "internal_B" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main2.id
  }
  depends_on = [aws_nat_gateway.main2]
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_A.id, aws_subnet.private_B.id]
  security_group_ids = [var.endpoint_sg]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_A.id, aws_subnet.private_B.id]
  security_group_ids = [var.endpoint_sg]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_A.id, aws_subnet.private_B.id]
  security_group_ids = [var.endpoint_sg]
}