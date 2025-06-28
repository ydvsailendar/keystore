resource "aws_efs_file_system" "oss_kafka_efs" {
  creation_token = "OssKafkaEfs"
  encrypted      = true
  kms_key_id     = aws_kms_key.oss_kms_key_efs.arn
  tags = {
    Name = "OssKafkaEfs"
  }
}

resource "aws_efs_mount_target" "oss_mt_kafka" {
  file_system_id  = aws_efs_file_system.oss_kafka_efs.id
  subnet_id       = aws_subnet.oss_app_subnet.id
  security_groups = [aws_security_group.oss_sg_efs.id]
}

resource "aws_efs_access_point" "oss_efs_access_point_kafka" {
  file_system_id = aws_efs_file_system.oss_kafka_efs.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/kafka-data"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0755"
    }
  }
  tags = {
    Name = "OssKafkaAccessPoint"
  }
}
