# ⚙️ Setup Guide

Follow the steps below to deploy the infrastructure on AWS using Terraform.

---

## 1. Clone the Repository

```bash
git clone <repository-url>
cd Terraform.git
```

---

## 2. Configure AWS Credentials

Ensure your AWS CLI is configured with valid credentials:

```bash
aws configure
```

You will be prompted to enter:

* AWS Access Key ID
* AWS Secret Access Key
* Default region (e.g., us-east-1)
* Output format (e.g., json)

---

## 3. Initialize Terraform

Download the required providers and initialize the working directory:

```bash
terraform init
```

---

## 4. Deploy Infrastructure

Apply the Terraform configuration to provision resources:

```bash
terraform apply
```

Type `yes` when prompted to confirm deployment.

---

## ✅ Deployment Complete

Once the process finishes, your infrastructure will be successfully created.
You can now access services via the Application Load Balancer (ALB).
