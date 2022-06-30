resource "aws_launch_template" "stg_main_ecs_on_ec2_launch_template" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = "30"
      volume_type = "gp2"
    }
  }
  ebs_optimized = "false"

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.ecsInstanceProfile.arn
  }

  image_id      = "ami-0825d169c70881cd7"
  instance_type = "t2.micro"
  key_name      = "${local.r_prefix}-key"

  monitoring {
    enabled = "true"
  }

  name                   = "ECS_on_EC2_${local.r_prefix}_launch_template"
  user_data              = base64encode(data.template_file.ecs_instance_sh.rendered)
  vpc_security_group_ids = ["${data.aws_security_group.public_sg.id}"]
}

data "template_file" "ecs_instance_sh" {
  template = <<EOF
#!/bin/bash
echo ECS_CLUSTER=stg-${local.r_prefix}-cluster >> /etc/ecs/ecs.config;
EOF
}