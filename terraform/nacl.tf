resource "aws_network_acl" "oss_app_nacl" {
  subnet_ids = [aws_subnet.oss_app_subnet.id]
  tags = {
    Name = "OssAppNacl"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_network_acl_rule" "oss_app_inbound_from_internet_on_empherial" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_app_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 65535
}

resource "aws_network_acl_rule" "oss_app_outbound_to_internet_on_https" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 443
  network_acl_id = aws_network_acl.oss_app_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 443
}

resource "aws_network_acl" "oss_db_az1_nacl" {
  subnet_ids = [aws_subnet.oss_db_subnet_az1.id]
  tags = {
    Name = "OssDbAz1Nacl"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_network_acl_rule" "oss_db_az1_inbound_from_internet_on_ephemeral_tcp" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_db_az1_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 65535
}

resource "aws_network_acl_rule" "oss_db_az1_outbound_to_internet_on_ephemeral_tcp" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_db_az1_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 110
  to_port        = 65535
}

resource "aws_network_acl" "oss_db_az2_nacl" {
  subnet_ids = [aws_subnet.oss_db_subnet_az2.id]
  tags = {
    Name = "OssDbAz2Nacl"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_network_acl_rule" "oss_db_az2_inbound_from_internet_on_ephemeral_tcp" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_db_az2_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 65535
}

resource "aws_network_acl_rule" "oss_db_az2_outbound_to_internet_on_ephemeral_tcp" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_db_az2_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 110
  to_port        = 65535
}

resource "aws_network_acl" "oss_public_nacl" {
  subnet_ids = [aws_subnet.oss_public_subnet.id]
  tags = {
    Name = "OssPublicNacl"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_network_acl_rule" "oss_public_inbound_from_internet_on_kafka_ui" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_public_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 65535
}

resource "aws_network_acl_rule" "oss_public_outbound_to_internet_on_https" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 443
  network_acl_id = aws_network_acl.oss_public_nacl.id
  protocol       = "6"
  rule_action    = "allow"
  rule_number    = 100
  to_port        = 443
}

resource "aws_network_acl_rule" "oss_public_outbound_to_internet_on_ephemeral_tcp" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  from_port      = 1024
  network_acl_id = aws_network_acl.oss_public_nacl.id
  protocol       = "-1"
  rule_action    = "allow"
  rule_number    = 110
  to_port        = 65535
}
