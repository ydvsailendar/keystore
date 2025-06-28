resource "aws_vpc" "oss_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "OssVpc"
  }
  depends_on = [aws_cloudwatch_log_group.oss_cw_log_group_vpc_flow]
}

resource "aws_flow_log" "oss_vpc_flow" {
  iam_role_arn    = aws_iam_role.oss_iam_role_vpc_flow.arn
  log_destination = aws_cloudwatch_log_group.oss_cw_log_group_vpc_flow.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.oss_vpc.id
  tags = {
    Name = "OssVpcFlow"
  }
}
