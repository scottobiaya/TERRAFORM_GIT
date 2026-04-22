# 🚀 Terraform AWS DevOps Infrastructure (Jenkins + Vault + ALB + ASG)

## 📌 Overview

This project provisions a complete AWS cloud infrastructure using **Terraform**, implementing a scalable and secure DevOps environment.

It includes:

- 🧱 Custom VPC with public/private subnets  
- ⚖️ Application Load Balancer (ALB) for traffic routing  
- 🔄 Auto Scaling Groups (ASG) for high availability  
- 🔐 HashiCorp Vault (secret management service on port 8200)  
- 🛠️ Jenkins CI/CD server (port 8080)  
- 🧭 Bastion host for secure SSH access  
- 🔒 Layered Security Groups for controlled access  
- 📦 Modular Terraform architecture  

---

# 🏗️ Architecture Diagram
                           Internet
                               |
                        [ ALB - main-lb-tf ]
                         /              \
                        /                \
             Jenkins TG (8080)      Vault TG (8200)
                    |                     |
        ---------------------     ---------------------
        |                   |     |                   |
   Jenkins ASG        Compute ASG   Vault ASG (3 nodes)
        |                   |     |
   EC2 Jenkins        EC2 App   EC2 Vault
        |
   Bastion Host (SSH entry point)
        |
   Private VPC (10.0.0.0/16)

   
    Terraform Project
│
├── main.tf
├── terraform.tfvars
├── output.tf
│
├── module/
│   ├── vpc/
│   ├── security/
│   ├── load_balancer/
│   ├── compute/
│   ├── jenkins_ASG/
│   ├── vault_ASG/
│
├── jenkins.sh
├── vault.sh
│
└── README.md
