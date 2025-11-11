#!/bin/bash
###########################################################
# GroceryMate EC2 Bootstrap Script - Terraform Ready
###########################################################

# Update and install dependencies
sudo yum update -y
sudo yum install -y git docker postgresql amazon-cloudwatch-agent -y

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

# Clean up any old containers or images
sudo docker stop $(sudo docker ps -aq) 2>/dev/null || true
sudo docker rm $(sudo docker ps -aq) 2>/dev/null || true
sudo docker system prune -af -y 2>/dev/null || true
sudo rm -f /var/log/grocerymate.log


# Build the Docker image
sudo docker build -t grocerymate .

# Run the Flask container connected to the RDS
sudo docker run -d \
  --name grocerymate_app \
  -p 80:5000 \
  --env-file .env \
  grocerymate

# Save logs locally (for backup)
sudo docker logs -f grocerymate_app > /var/log/grocerymate.log 2>&1 &

###########################################################
# Install and configure CloudWatch Agent
###########################################################

# Create config file for CloudWatch Agent
cat <<EOT >> /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/grocerymate.log",
            "log_group_name": "/aws/flask/grocerymate",
            "log_stream_name": "flask-container-{instance_id}"
          },
          { 
            "file_path": "/var/log/messages",
            "log_group_name": "/aws/flask/grocerymate",
            "log_stream_name": "system-{instance_id}"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": { "measurement": ["mem_used_percent"] },
      "cpu": { "measurement": ["cpu_usage_idle", "cpu_usage_iowait"] }
    }
  }
}
EOT

# Enable and start CloudWatch Agent
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent

# Confirm status
sudo systemctl status amazon-cloudwatch-agent
