output "main_lb" {
    value =aws_lb.main   
}

output "vault_TG" {
    value =  aws_lb_target_group.vault  
}

output "jenkins_TG" {
    value =aws_lb_target_group.jenkins  
}

output "alb_arn" {
  value = aws_lb.main.arn
}

# output "vault_tg_arn" {
#   value = aws_lb_target_group.vault.arn
# }

# output "jenkins_tg_arn" {
#   value = aws_lb_target_group.jenkins.arn
# }