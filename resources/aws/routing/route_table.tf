resource "aws_route_table" "main_public_route_table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.main_igw.id
  }

  tags = {
    Name    = "${local.r_prefix}-public-route-table"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-public-route-table"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}

resource "aws_route_table" "main_private_route_table" {
  tags = {
    Name    = "${local.r_prefix}-private-route-table"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-private-route-table"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}
