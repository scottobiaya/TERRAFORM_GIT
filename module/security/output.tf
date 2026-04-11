

output "alb_sg_id" {
  value = aws_security_group.ALB.id
}

output "vault_SG" {
  value= aws_security_group.vault.id
}

output "jenkins_SG" {
  value= aws_security_group.jenkins.id
}


