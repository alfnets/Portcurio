# SSMでログインするためのポリシー
resource "aws_iam_policy" "EC2ForSSMPolicy" {
  name = "EC2ForSSMPolicy"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    },
    {
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    },
    {
      "Action": [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    },
    {
      "Action": [
        "ssm:GetParametersByPath",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "s3:PutObject",
        "logs:PutLogEvents",
        "logs:CreateLogStream",
        "kms:Decrypt",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


# EC2のSSMロール
resource "aws_iam_role" "EC2ForSSMRole" {
  name               = "EC2ForSSMRole"
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
  "Version": "2012-10-17"
}
POLICY
}


# EC2のSSMロールにEC2にSSMでログインするためのポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "EC2ForSSMRole_EC2ForSSMPolicy_attachment" {
  policy_arn = aws_iam_policy.EC2ForSSMPolicy.arn
  role       = "EC2ForSSMRole"
}

# EC2にSSMでログインするためのポリシーをアタッチしたEC2のSSMロールのプロファイルを作成
resource "aws_iam_instance_profile" "EC2ForSSMProfile" {
  name = "EC2ForSSMProfile"
  path = "/"
  role = "EC2ForSSMRole"
}