# Fargateを操作するポリシー
resource "aws_iam_policy" "ecsFargateExecRolePolicy" {
  description = "ecsFargateExecRolePolicy"
  name        = "ecsFargateExecRolePolicy"
  path        = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


# ECSのタスクロール
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description = "Allows ECS tasks to call AWS services on your behalf."

  tags = {
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Service = "${local.r_prefix}"
  }
}


# ポリシーをロールにアタッチ
## ECSのタスクロールにECSタスクロールを実行するためのポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_ECSTaskExecutionRolePolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = "ecsTaskExecutionRole"
}

## ECSのタスクロールにS3へのフルアクセスポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_AmazonS3FullAccessPolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = "ecsTaskExecutionRole"
}

## ECSのタスクロールにSSMの読み取りポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_SSMReadOnlyAccessPolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = "ecsTaskExecutionRole"
}

## ECSのタスクロールにCloudWatchLogsへのフルアクセスポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_CloudWatchLogsFullAccessPolicy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = "ecsTaskExecutionRole"
}

## ECSのタスクロールにFargateを操作するポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_ecsFargateExecRolePolicy_attachment" {
  policy_arn = aws_iam_policy.ecsFargateExecRolePolicy.arn
  role       = "ecsTaskExecutionRole"
}