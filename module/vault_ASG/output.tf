output "user_data" {
    value = filebase64("${path.root}/vault.sh")  
}