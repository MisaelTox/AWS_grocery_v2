##############################
# locals.tf
# Common tags and reusable variables
##############################

# Common tags applied to all resources
locals {
  common_tags = {
    Project     = "GroceryMate"
    Environment = "dev"
    Owner       = "terraform"
  }
}
