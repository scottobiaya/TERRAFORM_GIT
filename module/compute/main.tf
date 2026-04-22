resource "aws_instance" "example" {
  ami           = "ami-0ea87431b78a82070"
  instance_type = "t2.micro"

  subnet_id = var.public_A_subnet_id

  vpc_security_group_ids = [var.security_compute, var.jenkins_SG]
  associate_public_ip_address = true
 key_name = var.key_name 

  tags = {
    Name = "HelloWorld"
  }
}

