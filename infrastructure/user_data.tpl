#!/bin/bash
###########################################################
# GroceryMate EC2 Bootstrapping Script
###########################################################

sudo yum update -y
sudo yum install -y git python3-pip postgresql

cd /home/ec2-user
git clone https://github.com/MisaelTox/AWS_grocery_v2.git
cd AWS_grocery_v2

pip3 install -r requirements.txt

cat <<EOF > .env
DB_HOST=${db_host}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
EOF

sudo mkdir -p /var/log/grocerymate
sudo chmod 777 /var/log/grocerymate

nohup python3 app.py > /var/log/grocerymate/app.log 2>&1 &

echo "nohup python3 /home/ec2-user/AWS_grocery_v2/app.py > /var/log/grocerymate/app.log 2>&1 &" | sudo tee -a /etc/rc.local
sudo chmod +x /etc/rc.local
 