resource "aws_security_group" "main_alb_sg" {
  description = "${local.r_prefix}-alb-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name = "${local.r_prefix}-alb-sg"

  tags = {
    Name    = "${local.r_prefix}-alb-sg"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-alb-sg"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}

resource "aws_security_group" "main_app_sg" {
  description = "${local.r_prefix}-app-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   from_port   = "0"
  #   protocol    = "-1"
  #   self        = "false"
  #   to_port     = "0"
  # }

  name = "${local.r_prefix}-app-sg"

  tags = {
    Name    = "${local.r_prefix}-app-sg"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-app-sg"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}

resource "aws_security_group" "main_public_sg" {
  description = "launch-wizard created 2022-04-18T05:59:44.063Z"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  name = "${local.r_prefix}-public-sg"

  tags = {
    Name    = "${local.r_prefix}-public-sg"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-public-sg"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}

resource "aws_security_group" "main_rds_sg" {
  description = "${local.r_prefix}-rds-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "3306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3306"
  }

  name = "${local.r_prefix}-rds-sg"

  tags = {
    Name    = "${local.r_prefix}-rds-sg"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-rds-sg"
    Service = "${local.r_prefix}"
  }

  vpc_id = data.aws_vpc.main_vpc.id
}
