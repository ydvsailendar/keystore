resource "random_string" "oss_random_user" {
  length  = 8
  special = false
  keepers = {
    Version = 1 # update for key rotation
  }
  upper   = false
  numeric = false
}

resource "random_password" "oss_random_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    Version = 1 # update for key rotation
  }
}
