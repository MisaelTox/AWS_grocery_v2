#!/bin/bash
###########################################################
# GroceryMate EC2 Bootstrap Script - Terraform Ready
###########################################################

# Actualiza e instala dependencias
sudo yum update -y
sudo yum install -y git docker postgresql

# Habilita e inicia Docker
sudo systemctl enable docker
sudo systemctl start docker

# Agrega ec2-user al grupo docker
sudo usermod -aG docker ec2-user

# Clona el proyecto
cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2

# Crea archivo de entorno (.env)
cat <<EOF > .env
DB_HOST=${db_host}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
EOF

# Construye la imagen Docker
sudo docker build -t grocerymate .

# Ejecuta el contenedor Flask conectado al RDS
sudo docker run -d \
  --name grocerymate_app \
  -p 80:5000 \
  --env-file .env \
  grocerymate

# Guarda logs
sudo docker logs -f grocerymate_app > /var/log/grocerymate.log 2>&1 &
