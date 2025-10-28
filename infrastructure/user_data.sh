#!/bin/bash
# === User Data Script for GroceryMate EC2 (by MisaelTox) ===

# Actualizar sistema
yum update -y

# Instalar dependencias
yum install -y git docker
systemctl enable docker
systemctl start docker

# Clonar repositorio
cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2

# Construir y ejecutar el contenedor con Docker
docker build -t grocerymate .
docker run -d -p 80:80 grocerymate

# Log
echo "GroceryMate v2 (by MisaelTox) deployed successfully" > /home/ec2-user/deploy.log
