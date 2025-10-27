#!/bin/bash
# === User Data Script for GroceryMate EC2 (by MisaelTox) ===

# Actualizar el sistema
apt update -y
apt upgrade -y

# Instalar dependencias
apt install -y git docker.io
systemctl enable docker
systemctl start docker

# Clonar repositorio (versión limpia)
cd /home/ubuntu
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2

# Construir y ejecutar el contenedor con Docker
docker build -t grocerymate .
docker run -d -p 80:80 grocerymate

# Guardar un registro de la instalación
echo "GroceryMate v2 (by MisaelTox) deployed successfully" > /home/ubuntu/deploy.log
repo
