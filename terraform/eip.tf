resource "aws_eip" "oss_eip" {
  domain = "vpc"
  tags = {
    Name = "OssEip"
  }
}
