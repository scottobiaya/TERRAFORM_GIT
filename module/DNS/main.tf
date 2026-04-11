module "load_balancer" {
  source = "./load_balancer"
  load_balancer = var.main_lb
}

resource "aws_route53_zone" "main" {
  name = "projectdomain.com"
}

resource "aws_route53_record" "jenkins" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "jenkins.projectdomain.com"
  type    = "A"

  alias {
    name                   = var.main_lb.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_zone" "main2" {
  name = "projectdomain.com"
}

resource "aws_route53_record" "vault" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "vault.projectdomain.com"
  type    = "A"

  alias {
    name                   = var.main_lb.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}