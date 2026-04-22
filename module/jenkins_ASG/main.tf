
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



resource "aws_launch_template" "jenkins" {
  name_prefix   = "jenkins"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.small"
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }
  key_name = "mykey2" 
  user_data = var.user_data
  vpc_security_group_ids = [var.jenkins_SG]
  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
  resource_type = "instance"

  tags = {
    Name = "jenkins"
  }
}
}

resource "aws_autoscaling_group" "jenkins" {
  vpc_zone_identifier = [
    var.private_A_subnet_id,
    var.private_B_subnet_id
  ]

  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  target_group_arns = [var.jenkins_tg_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 600

  launch_template {
    id      = aws_launch_template.jenkins.id
    version = "$Latest"
  }
depends_on = [var.jenkins_tg_arn]
  tag {
    key                 = "Name"
    value               = "jenkins"
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "jenkins-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "jenkins-ssm-profile"
  role = aws_iam_role.ssm_role.name
}