#!/bin/bash
set -e

# Update system packages
yum update -y

# Install dependencies
yum groupinstall -y "Development Tools"
yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make git

# Install Python 3.9 from source
cd /usr/src
wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tgz
tar xzf Python-3.9.18.tgz
cd Python-3.9.18
./configure --enable-optimizations
make altinstall

# Verify installation
python3.9 --version

# Clone your project repository
cd /home/ec2-user
git clone https://github.com/YOUR_GITHUB_USERNAME/AWS_grocery_v2.git
cd AWS_grocery_v2/backend

# Fix permissions
chown -R ec2-user:ec2-user /home/ec2-user/AWS_grocery_v2

# Create and activate a virtual environment
python3.9 -m venv venv
source venv/bin/activate

# Install project dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run the application (adjust as needed)
nohup python3.9 run.py > app.log 2>&1 &
