output "aws_network_acl_main_public_nacl_id" {
  value = aws_network_acl.main_public_nacl.id
}

output "aws_route_table_main_public_route_table_id" {
  value = aws_route_table.main_public_route_table.id
}

output "aws_route_table_main_private_route_table_id" {
  value = aws_route_table.main_private_route_table.id
}

output "aws_route_table_association_main_public_1_route_table_association_id" {
  value = aws_route_table_association.main_public_1_route_table_association.id
}

output "aws_route_table_association_main_public_2_route_table_association_id" {
  value = aws_route_table_association.main_public_2_route_table_association.id
}

output "aws_route_table_association_main_private_1_route_table_association_id" {
  value = aws_route_table_association.main_private_1_route_table_association.id
}

output "aws_route_table_association_main_private_2_route_table_association_id" {
  value = aws_route_table_association.main_private_2_route_table_association.id
}

output "aws_security_group_main_alb_sg_id" {
  value = aws_security_group.main_alb_sg.id
}

output "aws_security_group_main_app_sg_id" {
  value = aws_security_group.main_app_sg.id
}

output "aws_security_group_main_public_sg_id" {
  value = aws_security_group.main_public_sg.id
}

output "aws_security_group_main_rds_sg_id" {
  value = aws_security_group.main_rds_sg.id
}
