resource "aws_security_group" "oss_sg_kafka_ui_public" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgKafkaUi"
  tags = {
    Name = "OssSgKafkaUi"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_kafka_private" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9092
    to_port   = 9092
    protocol  = "tcp"
    security_groups = [
      aws_security_group.oss_sg_kafka_ui_public.id,
      aws_security_group.oss_sg_consumer_app_private.id,
      aws_security_group.oss_sg_producer_app_private.id
    ]
  }
  name = "OssSgKafka"
  tags = {
    Name = "OssSgKafka"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_efs" {
  name   = "OssSgEfs"
  vpc_id = aws_vpc.oss_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.oss_sg_kafka_private.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "oss_sg_dashboard_app_public" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgDashboardApp"
  tags = {
    Name = "OssSgDashboardApp"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_consumer_app_private" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgConsumerApp"
  tags = {
    Name = "OssSgConsumerApp"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_producer_app_private" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgProducerApp"
  tags = {
    Name = "OssSgProducerApp"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_migrator_private" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgMigrator"
  tags = {
    Name = "OssSgMigrator"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_security_group" "oss_sg_rds_db" {
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      aws_security_group.oss_sg_consumer_app_private.id,
      aws_security_group.oss_sg_dashboard_app_public.id,
      aws_security_group.oss_sg_migrator_private.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = "OssSgRdsDb"
  tags = {
    Name = "OssSgRdsDb"
  }
  vpc_id = aws_vpc.oss_vpc.id
}
