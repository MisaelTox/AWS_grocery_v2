#!/bin/bash
###########################################################
# GroceryMate EC2 Bootstrap Script - Terraform Ready
###########################################################

# Update and install dependencies
sudo yum update -y
sudo yum install -y git docker postgresql

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to the Docker group
sudo usermod -aG docker ec2-user

# Clone the project
cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2

# Create environment file (.env)
cat <<EOF > .env
DB_HOST=${db_host}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
EOF

# Build the Docker image
sudo docker build -t grocerymate .

# Run the Flask container connected to the RDS
sudo docker run -d \
  --name grocerymate_app \
  -p 80:5000 \
  --env-file .env \
  grocerymate

# Save logs
sudo docker logs -f grocerymate_app > /var/log/grocerymate.log 2>&1 &
