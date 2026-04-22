
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
