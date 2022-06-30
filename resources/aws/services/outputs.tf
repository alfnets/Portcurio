output "aws_ecs_cluster_main_ecs_cluster_id" {
  value = aws_ecs_cluster.main_ecs_cluster.id
}

output "aws_ecs_cluster_stg_main_ecs_cluster_id" {
  value = aws_ecs_cluster.stg_main_ecs_cluster.id
}

output "aws_ecs_service_main_ecs_service_id" {
  value = aws_ecs_service.main_ecs_service.id
}

output "aws_ecs_service_stg_main_ecs_service_id" {
  value = aws_ecs_service.stg_main_ecs_service.id
}

output "aws_ecs_task_definition_main_ecs_task_definition_id" {
  value = aws_ecs_task_definition.main_ecs_task_definition.id
}

output "aws_ecs_task_definition_stg_main_ecs_task_definition_id" {
  value = aws_ecs_task_definition.stg_main_ecs_task_definition.id
}

output "aws_eip_stg_main_ecs_on_ec2_eip_public_ip" {
  value = aws_eip.stg_main_ecs_on_ec2_eip.public_ip
}

output "data_aws_instance_stg_main_instance_id" {
  value = data.aws_instance.stg_main_instance.id
}

output "aws_route53_record_main_route53_record_A_id" {
  value = aws_route53_record.main_route53_record_A.id
}

output "aws_route53_record_stg_main_route53_record_A_id" {
  value = aws_route53_record.stg_main_route53_record_A.id
}

output "tags_of_most_recently_pushed_main_app_image" {
  description = ""
  value       = jsondecode(data.external.tags_of_most_recently_pushed_image.result.tags)[0]
}

output "aws_acm_certificate_main_acm_certificate_id" {
  value = aws_acm_certificate.main_acm_certificate.id
}

output "aws_lb_listener_rule_main_alb_listener_rule_id" {
  value = aws_lb_listener_rule.main_alb_listener_rule.id
}

output "aws_lb_listener_main_alb_listener_https_id" {
  value = aws_lb_listener.main_alb_listener_https.id
}

output "aws_lb_listener_main_alb_listener_http_id" {
  value = aws_lb_listener.main_alb_listener_http.id
}

output "aws_lb_target_group_main_alb_target_group_id" {
  value = aws_lb_target_group.main_alb_target_group.id
}

output "aws_lb_main_alb_id" {
  value = aws_lb.main_alb.id
}

output "aws_launch_template_stg_main_ecs_on_ec2_launch_template_id" {
  value = aws_launch_template.stg_main_ecs_on_ec2_launch_template.id
}