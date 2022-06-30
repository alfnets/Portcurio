resource "aws_internet_gateway" "main_igw" {
  tags = {
    Name    = "${local.r_prefix}-igw"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-igw"
    Service = "${local.r_prefix}"
  }

  vpc_id = aws_vpc.main_vpc.id
}
