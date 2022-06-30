resource "aws_autoscaling_group" "main_stg_autoscaling_group" {
  name                = "ECS_on_EC2_${local.r_prefix}_asg-${random_string.random_id.result}"
  vpc_zone_identifier = data.aws_subnets.public_subnets.ids
  launch_template {
    # id      = "lt-0d44ae1d384bfd567"
    name    = "ECS_on_EC2_${local.r_prefix}_launch_template"
    version = "$Default"
  }
  min_size                  = "0"
  max_size                  = "1"
  desired_capacity          = "1"
  health_check_grace_period = "0"
  protect_from_scale_in     = "false"
  capacity_rebalance        = "false"
  default_cooldown          = "300"
  force_delete              = "false"
  health_check_type         = "EC2"
  max_instance_lifetime     = "0"
  metrics_granularity       = "1Minute"
  wait_for_capacity_timeout = "10m"

  lifecycle {
    create_before_destroy = true
  }
}
