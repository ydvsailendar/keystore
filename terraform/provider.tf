terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
}

provider "aws" {
  allowed_account_ids = var.aws_allowed_account_ids
  default_tags {
    tags = {
      CostCenter = "P001"
      Department = "DevSecOps"
      ManagedBy  = "Terraform"
      Owner      = "devsecops@iamrootnexus.com"
      Project    = "OSS"
      Service    = "svc001-observability"
    }
  }
  max_retries = var.aws_max_retries
  profile     = var.aws_profile
  region      = var.aws_region
}
