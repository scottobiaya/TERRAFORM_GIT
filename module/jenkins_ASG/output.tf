output "user_data" {
    value = filebase64("${path.root}/jenkins.sh")  
}

# output "jenkins_tg_arn" {
#   value = aws_lb_target_group.jenkins.arn
# }