resource "aws_subnet" "oss_app_subnet" {
  cidr_block = "10.0.0.64/26"
  tags = {
    "Name" = "OssAppSubnet"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_subnet" "oss_db_subnet_az1" {
  availability_zone = "eu-west-2a"
  cidr_block        = "10.0.0.128/26"
  tags = {
    "Name" = "OssDbSubnetAz1"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_subnet" "oss_db_subnet_az2" {
  availability_zone = "eu-west-2b"
  cidr_block        = "10.0.0.192/26"
  tags = {
    "Name" = "OssDbSubnetAz2"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_subnet" "oss_public_subnet" {
  cidr_block = "10.0.0.0/26"
  tags = {
    "Name" = "OssPublicSubnet"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_db_subnet_group" "oss_db_subnet_group_keystore" {
  name = "keystroke"
  subnet_ids = [
    aws_subnet.oss_db_subnet_az1.id,
    aws_subnet.oss_db_subnet_az2.id
  ]

  tags = {
    Name = "OssDbSubnetGroup"
  }
}


