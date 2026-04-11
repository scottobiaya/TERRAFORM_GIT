output "cidr_blk" {
  value = "10.0.0.0/16"
}

output "public_A_subnet" {
    value = aws_subnet.public_A
  
}

output "private_B_subnet" {
    value = aws_subnet.public_B
  
}

output "private_A_subnet" {
    value = aws_subnet.private_A
  
}

output "public_B_subnet" {
    value = aws_subnet.private_B
  
}

output "vpc_id" {
  value = aws_vpc.main.id
}

