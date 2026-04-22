<<<<<<< HEAD
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
=======
# 🚀 AWS DevOps Infrastructure (Terraform)

## 📌 Project Overview

This project provisions a scalable and secure cloud infrastructure on AWS using Terraform. It demonstrates key DevOps principles, including Infrastructure as Code (IaC), automated provisioning, and high availability design.

The solution includes:

* Jenkins (CI/CD automation server)
* HashiCorp Vault (secrets management)
* Application Load Balancer (ALB)
* Auto Scaling Groups (ASG)
* Secure Virtual Private Cloud (VPC) architecture

---

## 🏗️ Architecture Overview

```
Internet → Application Load Balancer → (Jenkins / Vault) → EC2 Instances
```

---

## ⚡ Quick Start

Run the following commands to deploy the infrastructure:

```bash
terraform init
terraform apply
```

Confirm with `yes` when prompted.

---

## 🌐 Access Services

Once deployment is complete, access the services via the Application Load Balancer:

* **Jenkins:**
  http://main-lb-tf-1455850056.us-east-1.elb.amazonaws.com/jenkins

* **Vault:**
  http://main-lb-tf-1455850056.us-east-1.elb.amazonaws.com/vault/ui/

---

## 📚 Documentation

For more detailed information, refer to:

* 👉 [Architecture](docs/architecture.md)
* 👉 [Setup Guide](docs/setup-guide.md)
* 👉 [Troubleshooting](docs/troubleshooting.md)
>>>>>>> fbe98a2 (documentation)
