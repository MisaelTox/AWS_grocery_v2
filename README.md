# 🛒 GroceryMate — AWS Infrastructure Deployment with Terraform

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-v1.6+-623CE4?style=flat&logo=terraform&logoColor=white"/>
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?style=flat&logo=amazonaws&logoColor=white"/>
  <img src="https://img.shields.io/badge/Docker-Container-blue?style=flat&logo=docker&logoColor=white"/>
  <img src="https://img.shields.io/badge/PostgreSQL-Database-336791?style=flat&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Flask-Backend-black?style=flat&logo=flask&logoColor=white"/>
</p>

**Final project for the Masterschools Cloud Engineering Program**

---

## 🚀 Getting Started

**GroceryMate** is a modern e-commerce platform designed for online grocery shopping.  
This repository focuses on the **backend infrastructure deployment and automation** using **AWS Cloud Services** and **Terraform** as Infrastructure as Code (IaC).

The goal is to simulate a **scalable, production-ready architecture**, where a Flask application runs inside a Docker container on EC2, connected to an RDS PostgreSQL database, with static assets stored in S3 and logs monitored through CloudWatch.

See the **Deployment 📦** section to learn how to launch the project.

---

## 🧭 Architecture Diagram

<p align="center">
  <img src="grocerydia.png" alt="AWS Architecture Diagram" width="800">
</p>

---

### 📋 Prerequisites

Make sure you have the following installed and configured:

```bash
- AWS CLI with valid IAM credentials
- Terraform v1.6 or higher
- SSH key pair for EC2 access
- Git
🔧 Installation
Follow these steps to deploy the infrastructure:


# Clone the repository
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2/infrastructure

# (Optional) Use your AWS SSO profile if applicable
export <Your_Profile>

# Initialize Terraform
terraform init

# Validate the configuration
terraform validate

# Generate the execution plan
terraform plan

# Apply and create all resources
terraform apply
```

Once completed, Terraform will output:

- The public IP of the EC2 instance

- The endpoint of the RDS database

- The Flask application automatically starts inside the Docker container.

## ⚙️ Running Tests
### 🔩 Monitoring and Logs
You can monitor the system and check logs in two ways:

In the AWS Console:

- CloudWatch → Log groups → /aws/flask/grocerymate

Inside the EC2 instance:
```bash
sudo tail -f /var/log/grocerymate.log
```
### ⌨️ Metrics Monitored
CPU: cpu_usage_idle, cpu_usage_iowait

Memory: mem_used_percent

The CloudWatch Agent is automatically configured when the EC2 instance launches and continuously streams both logs and metrics in real time.

### 📦 Deployment
The full architecture is provisioned with Terraform and includes:

- EC2 (Amazon Linux 2): Flask application running in Docker
- RDS (PostgreSQL): main application database
- S3: static and media file storage
- CloudWatch: log and metric monitoring
- IAM: secure cross-service roles and policies
- VPC: private network with subnets and internet gateway

### 🧹 Cleanup
To destroy all resources and prevent charges:

```bash
terraform destroy
```
### 🛠️ Built With
Terraform — Infrastructure as Code
AWS — Cloud infrastructure provider
Docker — Containerization
PostgreSQL — Database
Flask — Backend framework

### 🖇️ Contributing
This project was developed as part of an educational program,
but contributions and improvements are always welcome via pull requests or issues.

### 📖 Wiki
The repository includes an architecture diagram (grocerydia.png) illustrating all main components.
You can explore the EC2 provisioning process inside the user_data.tpl file.


### ✒️ Authors
#### Original Application
   👤 Alejandro Román Ibáñez — Creator of the GroceryMate App
   🔗 GitHub: https://github.com/AlejandroRomanIbanez

#### AWS Infrastructure & Terraform Deployment
   👤 Misael Hernández
   🔗 GitHub: https://github.com/MisaelTox

### 📄 License
This project is licensed under the MIT License.
See the LICENSE file for details.

### 🎁 Acknowledgments
- Share this project 📢
- Invite the author for a coffee ☕ or a beer 🍺
- Leave a star ⭐ on GitHub to show support
- Keep building and learning 🤓

