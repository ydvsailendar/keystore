resource "aws_ecr_repository" "oss_ecr_repo_producer" {
  name                 = "oss_ecr_repo_producer"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "OssEcrRepoProducer"
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.oss_kms_key_ecr.arn
  }
}

resource "aws_ecr_repository" "oss_ecr_repo_consumer" {
  name                 = "oss_ecr_repo_consumer"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "OssEcrRepoConsumer"
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.oss_kms_key_ecr.arn
  }
}


resource "aws_ecr_repository" "oss_ecr_repo_dashboard" {
  name                 = "oss_ecr_repo_dashboard"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "OssEcrRepoDashboard"
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.oss_kms_key_ecr.arn
  }
}

resource "aws_ecr_repository" "oss_ecr_repo_migrator" {
  name                 = "oss_ecr_repo_migrator"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "OssEcrRepoMigrator"
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.oss_kms_key_ecr.arn
  }
}
