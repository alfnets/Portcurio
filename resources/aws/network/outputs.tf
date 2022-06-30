output "aws_vpc_main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "aws_subnet_public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "aws_subnet_public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "aws_subnet_private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "aws_subnet_private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

output "aws_internet_gateway_main_igw_id" {
  value = aws_internet_gateway.main_igw.id
}

output "aws_route53_zone_main_route53_zone_id" {
  value = aws_route53_zone.main_route53_zone.id
}