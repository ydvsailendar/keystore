terraform {
  backend "s3" {
    bucket       = "iamrootnexus"
    encrypt      = true
    key          = "oss/observability/terrafrom.tfstate"
    profile      = "iamrootnexus"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
