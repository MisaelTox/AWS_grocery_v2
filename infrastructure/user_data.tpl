#!/bin/bash
# === GroceryMate (Terraform) - EC2 Setup Script ===
# Instala dependencias, configura backend Flask, frontend y Nginx con reverse proxy

set -xe  # Habilita modo debug para registrar errores en cloud-init

# --- Actualizar sistema ---
yum update -y
yum install -y git nginx python3 python3-pip postgresql postgresql-devel gcc python3-devel

# --- Clonar el repositorio ---
cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2/backend

# --- Instalar dependencias del backend ---
pip3 install --upgrade pip setuptools wheel
pip3 install --no-cache-dir -r requirements.txt
pip3 install gunicorn

# --- Crear archivo .env con datos de conexión dinámicos ---
cat <<EOT > .env
JWT_SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
POSTGRES_USER=${db_username}
POSTGRES_PASSWORD=${db_password}
POSTGRES_DB=grocerymate_db
POSTGRES_HOST=${db_host}
POSTGRES_URI=postgresql://${db_username}:${db_password}@${db_host}:5432/grocerymate_db
EOT

# --- Crear servicio systemd para Gunicorn ---
cat <<EOF > /etc/systemd/system/grocerymate.service
[Unit]
Description=GroceryMate Backend
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/AWS_grocery_v2/backend
EnvironmentFile=/home/ec2-user/AWS_grocery_v2/backend/.env
ExecStart=/usr/local/bin/gunicorn -w 2 -b 0.0.0.0:5000 run:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable grocerymate
systemctl start grocerymate

# --- Instalar Node.js y construir el frontend ---
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
yum install -y nodejs
cd /home/ec2-user/AWS_grocery_v2/frontend
npm ci || npm install
npm run build

# --- Configurar Nginx como reverse proxy y servidor estático ---
rm -rf /usr/share/nginx/html/*
cp -r dist/* /usr/share/nginx/html/ 2>/dev/null || cp -r build/* /usr/share/nginx/html/

cat <<EOF > /etc/nginx/conf.d/grocerymate.conf
server {
    listen 80;
    server_name _;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files \$uri /index.html;
    }

    location /api {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl enable nginx
systemctl restart nginx

echo "✅ GroceryMate deployed successfully" > /home/ec2-user/deploy.log