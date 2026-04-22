# 🏗️ Architecture

## Overview

This project uses AWS services to build a scalable system.

Flow:

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


---

## Components

- VPC (network)
- ALB (traffic routing)
- Jenkins (CI/CD)
- Vault (secrets)
- Auto Scaling Groups (scaling)