module "vpc" {

  source = "./vpc"
  vpc= var.vpc
  private_A_subnet = var.private_A_subnet
  private_B_subnet = var.private_B_subnet
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "vault" {
  name_prefix   = "vault"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data = filebase64("${path.module}/./vault.sh")
  vpc_security_group_ids = [var.vault_SG.id]
  
}

resource "aws_autoscaling_group" "vault" {
 vpc_zone_identifier = [var.private_A_subnet.id, var.private_B_subnet.id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  target_group_arns = [aws_lb_target_group.vault.arn]
  

  launch_template {
    id      = aws_launch_template.vault.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "jenkins" {
  name_prefix   = "jenkins"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data = filebase64("${path.module}/./jenkins.sh")
  vpc_security_group_ids = [var.jenkins_SG.id]
}

resource "aws_autoscaling_group" "jenkins" {
 vpc_zone_identifier = [var.private_A_subnet.id, var.private_B_subnet.id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
 target_group_arns = [aws_lb_target_group.jenkins.arn] 
  

  launch_template {
    id      = aws_launch_template.jenkins.id
    version = "$Latest"
  }
}