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
  public_A_subnet = var.public_A_subnet
  private_A_subnet = var.private_A_subnet
  public_B_subnet = var.public_B_subnet
  private_B_subnet = var.private_B_subnet
}

module "load_balancer" {
  source = "./module/load_balancer"
 vault_TG = var.vault_TG
 jenkins_TG = var.jenkins_TG
ALB_SG_id = module.security.alb_sg_id
 vpc_id = module.vpc.vpc_id
 public_B_subnet = module.vpc.public_B_subnet
 public_A_subnet = module.vpc.public_A_subnet
}

module "security" {
  source = "./module/security"
  vpc_id = module.vpc.vpc_id
  ALB_SG_id =var.ALB_SG
  vault_SG = var.vault_SG
  jenkins_SG = var.jenkins_SG  
}

