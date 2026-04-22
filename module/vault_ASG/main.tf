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
  instance_type = "t3.small"

  key_name = "mykey2" 
 user_data= var.user_data
  vpc_security_group_ids = [var.vault_SG]
  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
  resource_type = "instance"
  

  tags = {
    Name = "vault"
  }
}
}

resource "aws_autoscaling_group" "vault" {
   name = "vault-asg"
 vpc_zone_identifier = [
  var.private_A_subnet_id,
  var.private_B_subnet_id
]
health_check_type = "ELB"
health_check_grace_period = 120
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  target_group_arns = [var.vault_tg_arn]
  
  

  launch_template {
    id      = aws_launch_template.vault.id
    version = "$Latest"

    
  }
  
    tag {
    key                 = "Name"
    value               = "vault"
    propagate_at_launch = true
  }
  
}

# resource "aws_iam_role" "ssm_role" {
#   name = "vault-ssm-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ssm_attach" {
#   role       = aws_iam_role.ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_instance_profile" "ssm_profile" {
#   name = "vault-ssm-profile"
#   role = aws_iam_role.ssm_role.name
# }