terraform {
  backend "s3" {
    bucket         = "terrafrom-state-scott"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}



module "vpc" {
  source = "./module/vpc"  
  cidr_blk = var.cidr_blk
  endpoint_sg = module.security.endpoint_sg
}

module "load_balancer" {
  source = "./module/load_balancer"
  vpc_id = module.vpc.vpc_id
  public_A_subnet = module.vpc.public_A_subnet_id
  public_B_subnet = module.vpc.public_B_subnet_id
  ALB_SG_id = module.security.alb_sg_id
  vault_TG   = var.vault_TG
  jenkins_TG = var.jenkins_TG
}
module "security" {
  source = "./module/security"
  vpc_id = module.vpc.vpc_id
  ALB_SG_id =var.ALB_SG
  vault_SG = var.vault_SG
  jenkins_SG = var.jenkins_SG 
  endpoint_sg = var.endpoint_sg
}

module "jenkins_ASG" {
  source = "./module/jenkins_ASG"
jenkins_SG = module.security.jenkins_SG

jenkins_tg_arn = module.load_balancer.jenkins_tg_arn
private_A_subnet_id = module.vpc.private_A_subnet_id
private_B_subnet_id = module.vpc.private_B_subnet_id
key_name = "mykey2"
user_data = filebase64("${path.root}/jenkins.sh") 


}

module "vault_ASG" {
  source = "./module/vault_ASG"
  vault_tg_arn   = module.load_balancer.vault_tg_arn
    user_data = filebase64("${path.root}/vault.sh") 
    vault_SG = module.security.vault_SG
    private_A_subnet_id = module.vpc.private_A_subnet_id
private_B_subnet_id = module.vpc.private_B_subnet_id
}

module "compute" {
  source = "./module/compute"
   public_A_subnet_id = module.vpc.public_A_subnet_id
security_compute = module.security.security_compute 
jenkins_SG = module.security.jenkins_SG
key_name = "mykey2"
}

