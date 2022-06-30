# EC2のロール
resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole"
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  description = "Allows EC2 instances in an ECS cluster to access ECS."

  tags = {
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Service = "${local.r_prefix}"
  }
}


# EC2のロールにECSを操作するためのポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsInstanceRole_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = "ecsInstanceRole"
}


# ECSを操作するためのポリシーをアタッチしたECSのロールのプロファイルを作成
resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile"
  path = "/"
  role = "ecsInstanceRole"
}