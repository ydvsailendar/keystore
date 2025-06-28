resource "aws_nat_gateway" "oss_nat" {
  allocation_id = aws_eip.oss_eip.id
  subnet_id     = aws_subnet.oss_public_subnet.id
  tags = {
    Name = "OssNat"
  }
}
