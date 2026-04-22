# 🛠️ Troubleshooting Guide

This section documents real-world issues encountered during deployment and how they were resolved. It demonstrates debugging across networking, IAM, compute, and service layers in a production-style AWS environment.

---

## ❌ Vault Service Not Running

### Symptoms

* ALB target marked **unhealthy**
* Health check failures on port `8200`
* Local endpoint not responding:

```bash
curl http://localhost:8200/v1/sys/health
```

### Root Cause

Vault failed to start due to misconfiguration and conflicting startup approaches (Docker vs systemd).

### Resolution

Standardised deployment using systemd service:

```bash
systemctl daemon-reload
systemctl enable vault
systemctl restart vault
```

Verification:

```bash
systemctl status vault
```

---

## ❌ ALB Target Group Unhealthy

### Symptoms

* Targets marked `unhealthy`
* Health check failures on port `8200`
* Traffic not reaching Vault service

### Root Cause

* Vault not running consistently on all instances
* Incorrect security group or port exposure
* Health check endpoint failing

### Resolution

* Ensured Vault listens on port `8200`
* Verified ALB security group access
* Confirmed health endpoint:

```bash
curl http://localhost:8200/v1/sys/health
```

---

## ❌ SSH Access Issues (Permission Denied)

### Symptoms

```bash
Permission denied (publickey)
```

### Root Cause

* Incorrect key pair usage
* Missing `.pem` file on bastion host
* Incorrect file permissions

### Resolution

* Transferred key to bastion host
* Applied correct permissions:

```bash
chmod 400 mykey2.pem
```

* Connected using:

```bash
ssh -i mykey2.pem ec2-user@<private-ip>
```

---

## ❌ SSH Timeout to Private Instances

### Symptoms

```bash
ssh: connect to host <private-ip> port 22: Connection timed out
```

### Root Cause

* Security group did not allow SSH from bastion
* Incorrect inbound rules for port 22

### Resolution

* Allowed SSH access from bastion/compute security group
* Verified VPC CIDR routing and subnet configuration

---

## ❌ AWS CLI Not Working on Bastion

### Symptoms

```bash
Unable to locate credentials
```

### Root Cause

* EC2 instance had no IAM role attached

### Resolution

* Attached IAM instance profile with required permissions
* Alternatively configured manually:

```bash
aws configure
```

---

## ❌ Auto Scaling Group Not Updating

### Symptoms

* Old instances still running after changes
* New configuration not applied

### Root Cause

* Launch template updated but ASG not refreshed

### Resolution

Triggered instance refresh:

```bash
aws autoscaling start-instance-refresh \
--auto-scaling-group-name vault-asg
```

---

## ❌ Vault Not Installed / Service Not Listening

### Symptoms

```bash
ss -tulnp | grep 8200
```

No output returned

### Root Cause

* User data script failed during provisioning
* Installation step not executed properly

### Resolution

* Checked logs:

```bash
cat /var/log/user-data.log
```

* Fixed user-data script and redeployed infrastructure

---

## ❌ Jenkins Access Requires SSM (No Direct SSH)

### Symptoms

* Cannot SSH directly into Jenkins instances
* Bastion access not sufficient for debugging Jenkins issues

### Root Cause

* Jenkins runs in private subnet with restricted SSH access
* SSH intentionally disabled for security hardening

### Resolution (SSM + IAM Instance Profile Setup)

* Installed **SSM agent support via IAM role**
* Created and attached instance profile:

```json
AmazonSSMManagedInstanceCore
```

* Attached IAM role to Jenkins EC2 instances via Terraform:

```hcl
iam_instance_profile {
  name = aws_iam_instance_profile.ssm_profile.name
}
```

* Accessed Jenkins instances securely using:

```bash
aws ssm start-session --target <instance-id>
```

### Outcome

* Removed need for SSH access to Jenkins
* Improved security (no exposed key-based login)
* Enabled secure debugging via AWS Systems Manager

---

## ✅ Key Lessons Learned

* Always validate service health using `systemctl` and `curl`
* ALB health checks must match real application ports
* Avoid mixing Docker and systemd for the same service
* IAM roles are essential for secure AWS CLI access on EC2
* Use SSM instead of SSH for production-grade security
* Always trigger ASG instance refresh after infrastructure updates
* User data logs are critical for debugging EC2 provisioning failures

---
