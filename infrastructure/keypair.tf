# Generate a new SSH key pair locally
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS as a Key Pair
resource "aws_key_pair" "main" {
  key_name   = "grocerymate-v2-key"
  public_key = tls_private_key.main.public_key_openssh
}

# Save the private key locally as a .pem file (safe on your machine only)
resource "local_file" "private_key" {
  filename        = "${path.module}/grocerymate-v2-key.pem"
  content         = tls_private_key.main.private_key_pem
  file_permission = "0600"
}

# Output for reference
output "private_key_path" {
  value       = local_file.private_key.filename
  description = "Path to your generated PEM key file"
}

