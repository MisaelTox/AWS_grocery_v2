#!/bin/bash
# === GroceryMate (Free Tier) - EC2 Setup Script ===

# Actualizar sistema e instalar dependencias esenciales
yum update -y
yum install -y git nginx python3 python3-pip postgresql

# Clonar el repositorio
cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2/backend

# Instalar dependencias del backend
pip3 install --no-cache-dir -r requirements.txt
pip3 install gunicorn

# Crear archivo .env (conexión a RDS)
cat <<EOT > .env
JWT_SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
POSTGRES_USER=${var.db_username}
POSTGRES_PASSWORD=${var.db_password}
POSTGRES_DB=grocerymate_db
POSTGRES_HOST=${aws_db_instance.grocerymate_rds.address}
POSTGRES_URI=postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.grocerymate_rds.address}:5432/grocerymate_db
EOT

# Iniciar backend Flask (ligero) en puerto 5000
nohup gunicorn -w 2 -b 0.0.0.0:5000 run:app &

# === Frontend ===
cd /home/ec2-user/AWS_grocery_v2/frontend
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
npm ci || npm install
npm run build

# Reemplazar contenido en Nginx con el build del frontend
rm -rf /usr/share/nginx/html/*
cp -r dist/* /usr/share/nginx/html/ 2>/dev/null || cp -r build/* /usr/share/nginx/html/

# Configurar Nginx (reverse proxy + frontend)
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
