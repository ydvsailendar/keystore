resource "aws_route_table" "oss_app_rt" {
  tags = {
    Name = "OssAppRt"
  }
  vpc_id = aws_vpc.oss_vpc.id
}


resource "aws_route_table_association" "oss_app_rt_attach_to_app_subnet" {
  subnet_id      = aws_subnet.oss_app_subnet.id
  route_table_id = aws_route_table.oss_app_rt.id
}

resource "aws_route" "oss_app_rt_route_to_internet_via_nat" {
  route_table_id         = aws_route_table.oss_app_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.oss_nat.id
}

resource "aws_route_table" "oss_db_az1_rt" {
  tags = {
    Name = "OssDbRtAz1"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_route_table_association" "oss_db_az1_rt_attach_to_db_subnet" {
  subnet_id      = aws_subnet.oss_db_subnet_az1.id
  route_table_id = aws_route_table.oss_db_az1_rt.id
}

resource "aws_route_table" "oss_db_az2_rt" {
  tags = {
    Name = "OssDbRtAz2"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_route_table_association" "oss_db_az2_rt_attach_to_db_subnet" {
  subnet_id      = aws_subnet.oss_db_subnet_az2.id
  route_table_id = aws_route_table.oss_db_az2_rt.id
}

resource "aws_route_table" "oss_public_rt" {
  tags = {
    Name = "OssPublicRt"
  }
  vpc_id = aws_vpc.oss_vpc.id
}

resource "aws_route_table_association" "oss_public_rt_attach_to_public_subnet" {
  subnet_id      = aws_subnet.oss_public_subnet.id
  route_table_id = aws_route_table.oss_public_rt.id
}

resource "aws_route" "oss_public_rt_route_to_internet_via_ig" {
  route_table_id         = aws_route_table.oss_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.oss_ig.id
}
