resource "aws_internet_gateway" "oss_ig" {
  tags = {
    Name = "OssIg"
  }
  vpc_id = aws_vpc.oss_vpc.id
}
