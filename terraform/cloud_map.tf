resource "aws_service_discovery_private_dns_namespace" "oss_ns" {
  description = "Private DNS namespace for OSS ECS services"
  name        = "oss.local"
  tags = {
    Name = "OssNs"
  }
  vpc = aws_vpc.oss_vpc.id
}

resource "aws_service_discovery_service" "oss_sd_kafka" {
  name = "kafka"
  dns_config {
    dns_records {
      ttl  = 60
      type = "A"
    }
    namespace_id   = aws_service_discovery_private_dns_namespace.oss_ns.id
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
  tags = {
    Name = "OssSdKafka"
  }
}
