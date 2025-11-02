##############################
# locals.tf
# Common tags and reusable variables
##############################

# Etiquetas comunes aplicadas a todos los recursos
locals {
  common_tags = {
    Project     = "GroceryMate"
    Environment = "dev"
    Owner       = "terraform"
  }
}
