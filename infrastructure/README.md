# 🛒 GroceryMate — AWS Infrastructure Deployment with Terraform

**Final project for the Masterschools Cloud Engineering Program**

---

## 🚀 Overview

**GroceryMate** is a modern e-commerce platform designed for online grocery shopping.  
This project focuses on deploying its backend infrastructure using **AWS Cloud Services** and **Terraform** as Infrastructure as Code (IaC).

The goal is to simulate a **scalable, production-ready architecture** where a Flask application runs inside a Docker container on EC2, connected to an RDS PostgreSQL database, with static content stored in S3 and logs monitored via CloudWatch.

---

## 🧭 Architecture Diagram
![AWS Architecture Diagram](grocery.png)



Core components:

- **EC2 Instance (Amazon Linux 2)** — Runs the Dockerized Flask app  
- **Amazon RDS (PostgreSQL)** — Hosts the main application database  
- **Amazon S3** — Used for static assets and media storage  
- **Amazon CloudWatch** — Monitors system metrics and application logs  
- **IAM Roles & Policies** — Provide secure cross-service permissions  
- **VPC & Networking** — Manages subnets, routing, and secure access  
- **Terraform** — Provisions and automates all AWS resources  

---

## ⚙️ Terraform Project Structure

| File | Description |
|------|--------------|
| `provider.tf` | Configures AWS provider and region |
| `network.tf` | Sets up VPC, subnets, route tables, and internet gateway |
| `ec2.tf` | Creates EC2 instance and attaches the user data bootstrap script |
| `rds.tf` | Deploys RDS PostgreSQL instance |
| `s3.tf` | Creates S3 bucket for static file storage |
| `iam.tf` | Defines IAM roles and instance profiles |
| `loggin.tf` | Configures CloudWatch log groups and policies |
| `variables.tf` | Declares input variables for Terraform |
| `outputs.tf` | Displays useful output values (public IP, DB endpoint) |
| `user_data.tpl` | EC2 bootstrap script to install dependencies, deploy Docker, and configure CloudWatch Agent |

---

## 🧩 EC2 User Data Workflow

When the EC2 instance is launched, it automatically:

1. Updates system packages and installs dependencies (`git`, `docker`, `postgresql`).
2. Clones this repository from GitHub.
3. Builds a Docker image for the Flask backend.
4. Runs the container on port 80, linked to the RDS database.
5. Writes logs to `/var/log/grocerymate.log`.
6. Installs and configures the **CloudWatch Agent** for log and metric collection.

---

## ☁️ CloudWatch Integration

To ensure observability and reliability, the **Amazon CloudWatch Agent** was implemented to stream logs and metrics from the EC2 instance.

**Logs Collected:**
- `/var/log/grocerymate.log`: Application logs from the Flask Docker container.  
- `/var/log/messages`: System logs and instance-level events.

**Metrics Monitored:**
- CPU utilization (`cpu_usage_idle`, `cpu_usage_iowait`)  
- Memory usage (`mem_used_percent`)

**Benefits:**
- Real-time visibility into system performance.  
- Centralized log management in AWS CloudWatch Console.  
- Simplified debugging without SSH access.  
- Ready for integration with CloudWatch Alarms and SNS notifications.

---

## 🗄️ Database Integration (Amazon RDS)

The EC2 container connects to the PostgreSQL RDS instance using environment variables dynamically injected by Terraform through `user_data.tpl`.  
Credentials and endpoints are automatically generated and securely managed.

---

## 🧱 Deployment Guide

### Prerequisites
- AWS CLI configured with IAM credentials  
- Terraform v1.6+ installed  
- SSH key pair for EC2 access  

### Steps

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Once applied, Terraform outputs the EC2 public IP and RDS endpoint.  
The Flask app automatically starts within the EC2 container.

---

## 📊 Monitoring & Logs

You can verify logs directly in the **AWS CloudWatch Console** under:

```
Log groups → /aws/flask/grocerymate
```

Or view them inside the EC2 instance:

```bash
sudo tail -f /var/log/grocerymate.log
```

---

## 🧹 Cleanup

To tear down all resources and avoid costs:

```bash
terraform destroy
```

---

## 🌱 Future Improvements

- Add an Application Load Balancer (ALB) for scalability.  
- Enable Auto Scaling Groups for high availability.  
- Configure CloudWatch Alarms and SNS notifications.  
- Add a CI/CD pipeline using GitHub Actions.  

---

## 🧾 Credits

**Original Application:**  
👤 *Alejandro Román Ibáñez* — Creator of the GroceryMate App  
🔗 [GitHub: AlejandroRomanIbanez](https://github.com/AlejandroRomanIbanez)

**AWS Infrastructure & Terraform Deployment:**  
👤 *Misael Hernández*  
🔗 [GitHub: MisaelTox](https://github.com/MisaelTox)

---

*All resources provisioned with Terraform.*
