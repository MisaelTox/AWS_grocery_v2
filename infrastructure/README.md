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
- **Amazon CloudWatch** — Collects and centralizes application and system logs  
- **IAM Roles & Policies** — Provide secure cross-service permissions  
- **VPC & Networking** — Manages subnets, routing, and secure access  
- **Terraform (modular)** — Provisions and automates all AWS resources

---

## ⚙️ Terraform Project Structure

This folder contains the Terraform entrypoint for the infrastructure.  
The actual AWS resources are created using **reusable modules** located in the top-level `modules/` directory.

### Infrastructure folder

| File             | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `provider.tf`    | Configures AWS provider and region                                          |
| `main.tf`        | Calls the Terraform modules (network, compute, database, storage, IAM, CloudWatch) and wires inputs/outputs |
| `variables.tf`   | Declares input variables for the infrastructure layer                       |
| `user_data.tpl`  | EC2 bootstrap script to install dependencies, deploy Docker, and configure logging |

### Modules (top-level `modules/` directory)

| Module                  | Description                                                         |
|-------------------------|---------------------------------------------------------------------|
| `modules/network`       | VPC, subnets, route tables, Internet Gateway and security groups    |
| `modules/compute`       | EC2 instance, security group, instance profile and user data usage  |
| `modules/database`      | RDS PostgreSQL instance, subnet group and DB security group         |
| `modules/storage`       | S3 bucket for static and media file storage                         |
| `modules/iam`           | IAM roles and policies for EC2 → S3 and EC2 → CloudWatch            |
| `modules/cloudwatch`    | CloudWatch log group configuration used by the EC2 instance         |

This modular structure keeps the infrastructure **organized, reusable and easier to maintain**.

---

## 🧩 EC2 User Data Workflow

When the EC2 instance is launched, the `user_data.tpl` script automatically:

1. Updates system packages and installs dependencies (`git`, `docker`, `postgresql`).  
2. Clones this repository from GitHub.  
3. Builds a Docker image for the Flask backend.  
4. Runs the container on port 80, linked to the RDS database using environment variables passed from Terraform.  
5. Writes logs to `/var/log/grocerymate.log`.  
6. Installs and configures the **CloudWatch Agent** for log collection.

This allows the application to be deployed automatically without manual SSH configuration.

---

## ☁️ CloudWatch Integration

To ensure observability and reliability, the **Amazon CloudWatch Agent** is used to stream logs from the EC2 instance.

**Logs collected include:**

- `/var/log/grocerymate.log`: Application logs from the Flask Docker container  
- `/var/log/messages`: System logs and instance-level events  

This provides:

- Centralized log management in the AWS CloudWatch Console  
- Easier debugging and monitoring of the instance and application  
- A foundation for adding CloudWatch Alarms and SNS notifications in the future  

---

## 🗄️ Database Integration (Amazon RDS)

The EC2 container connects to the PostgreSQL RDS instance using environment variables managed by Terraform.  
Terraform injects values such as:

- Database endpoint  
- Database name  
- Username  
- Password  
- Port  

This avoids hard-coding credentials and keeps configuration in a single, reproducible place.

---

## 🧱 Deployment Guide

### Prerequisites

- AWS CLI configured with an IAM user or SSO  
- Terraform v1.6+ installed  
- SSH key pair available for EC2 access (if needed)

### Steps

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Once the apply completes, Terraform outputs the EC2 public IP and the RDS endpoint.
The Flask app starts automatically inside the Docker container on the EC2 instance.

---

## 📊 Monitoring & Logs

You can verify logs directly in the AWS CloudWatch Console, under the log group created by the CloudWatch module.

On the EC2 instance, you can also inspect logs manually:

```
Log groups → /aws/flask/grocerymate
```

Or view them inside the EC2 instance:

```bash
sudo tail -f /var/log/grocerymate.log
```

---

## 🧹 Cleanup

To destroy all resources and avoid ongoing AWS charges:

```bash
terraform destroy
```

This command removes the EC2 instance, RDS database, S3 bucket, networking components and all related infrastructure created by this configuration.
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
