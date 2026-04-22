
resource "aws_lb" "main" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB_SG_id]
  subnets            = [
  var.public_A_subnet,
  var.public_B_subnet
]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}


resource "aws_lb_listener_rule" "vault" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }

  condition {
    path_pattern {
      values = ["/vault*"]
    }
  }
}

resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  } 

 condition {
    path_pattern {
      values = ["/jenkins*"]
    }
  }
}


resource "aws_lb_target_group" "vault" {
  name     = "vault-lb-tg"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5

    path    = "/v1/sys/health?standbyok=true"
    matcher = "200-499"
  }
}

resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id



  health_check {
    enabled = true
    timeout = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval = 30
    matcher = "200-399"
    path =  "/jenkins"
  }
}

