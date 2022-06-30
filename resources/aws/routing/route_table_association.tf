resource "aws_route_table_association" "main_public_1_route_table_association" {
  route_table_id = aws_route_table.main_public_route_table.id
  subnet_id      = data.aws_subnet.main_public_subnet_1.id
}

resource "aws_route_table_association" "main_public_2_route_table_association" {
  route_table_id = aws_route_table.main_public_route_table.id
  subnet_id      = data.aws_subnet.main_public_subnet_2.id
}

resource "aws_route_table_association" "main_private_1_route_table_association" {
  route_table_id = aws_route_table.main_private_route_table.id
  subnet_id      = data.aws_subnet.main_private_subnet_1.id
}

resource "aws_route_table_association" "main_private_2_route_table_association" {
  route_table_id = aws_route_table.main_private_route_table.id
  subnet_id      = data.aws_subnet.main_private_subnet_2.id
}