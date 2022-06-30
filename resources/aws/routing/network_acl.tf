resource "aws_network_acl" "main_public_nacl" {

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "22"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "200"
    to_port    = "80"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "300"
    to_port    = "443"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "400"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "500"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "22"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "200"
    to_port    = "80"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "300"
    to_port    = "443"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "400"
    to_port    = "65535"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "500"
    to_port    = "0"
  }

  subnet_ids = data.aws_subnets.public_subnets.ids

  tags = {
    Name    = "${local.r_prefix}-public-nacl"
    Service = "${local.r_prefix}"
    Privacy = "public"
  }

  tags_all = {
    Name    = "${local.r_prefix}-public-nacl"
    Service = "${local.r_prefix}"
    Privacy = "public"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}


resource "aws_network_acl" "main_private_nacl" {

  ingress {
    action     = "allow"
    cidr_block = data.aws_vpc.main_vpc.cidr_block
    from_port  = "3306"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "3306"
  }

  egress {
    action     = "allow"
    cidr_block = data.aws_vpc.main_vpc.cidr_block
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "65535"
  }

  subnet_ids = data.aws_subnets.private_subnets.ids

  tags = {
    Name    = "${local.r_prefix}-private-nacl"
    Service = "${local.r_prefix}"
    Privacy = "private"
  }

  tags_all = {
    Name    = "${local.r_prefix}-private-nacl"
    Service = "${local.r_prefix}"
    Privacy = "private"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}