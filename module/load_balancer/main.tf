
resource "aws_acm_certificate" "vault" {
  domain_name       = "vault.com"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }
}

resource "aws_acm_certificate" "jenkins" {
  domain_name       = "jenkins.com"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb" "main" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB_SG_id]
  subnets            = [var.public_B_subnet.id, var.public_A_subnet.id]

  enable_deletion_protection = true


  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
   certificate_arn   = aws_acm_certificate.vault.arn

default_action {
  type = "fixed-response"

  fixed_response {
    content_type = "text/plain"
    message_body = "Invalid request"
    status_code  = "404"
  }
}
}

resource "aws_lb_listener_certificate" "jenkins" {
  listener_arn    = aws_lb_listener.main.arn
  certificate_arn = aws_acm_certificate.jenkins.arn
}

resource "aws_lb_listener_rule" "vault" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }

  condition {
    host_header {
      values = ["vault.yourdomain.com"]
    }
  }
}

resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  } 

  condition {
    host_header {
      values = ["jenkins.projectdomain.com"]
    }
  }
}


resource "aws_lb_target_group" "vault" {
  name     = "vault-lb-tg"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 30
    matcher = "200"
    path = "/"
  }
}

resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 30
    matcher = "200"
    path = "/login"
  }
}