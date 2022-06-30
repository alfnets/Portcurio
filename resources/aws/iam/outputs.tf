output "aws_iam_instance_profile_EC2ForSSMProfile_id" {
  value = aws_iam_instance_profile.EC2ForSSMProfile.id
}

output "aws_iam_instance_profile_ecsInstanceProfile_id" {
  value = aws_iam_instance_profile.ecsInstanceProfile.id
}

output "aws_iam_policy_EC2ForSSMPolicy_id" {
  value = aws_iam_policy.EC2ForSSMPolicy.id
}

output "aws_iam_policy_ecsFargateExecRolePolicy_id" {
  value = aws_iam_policy.ecsFargateExecRolePolicy.id
}

output "aws_iam_role_EC2ForSSMRole_id" {
  value = aws_iam_role.EC2ForSSMRole.id
}

output "aws_iam_role_ecsInstanceRole_id" {
  value = aws_iam_role.ecsInstanceRole.id
}

output "aws_iam_role_ecsTaskExecutionRole_id" {
  value = aws_iam_role.ecsTaskExecutionRole.id
}

output "aws_iam_role_policy_attachment_EC2ForSSMRole_EC2ForSSMPolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.EC2ForSSMRole_EC2ForSSMPolicy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsInstanceRole_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsInstanceRole_policy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsTaskExecutionRole_ECSTaskExecutionRolePolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsTaskExecutionRole_ECSTaskExecutionRolePolicy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsTaskExecutionRole_AmazonS3FullAccessPolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsTaskExecutionRole_AmazonS3FullAccessPolicy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsTaskExecutionRole_SSMReadOnlyAccessPolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsTaskExecutionRole_SSMReadOnlyAccessPolicy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsTaskExecutionRole_CloudWatchLogsFullAccessPolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsTaskExecutionRole_CloudWatchLogsFullAccessPolicy_attachment.id
}

output "aws_iam_role_policy_attachment_ecsTaskExecutionRole_ecsFargateExecRolePolicy_attachment_id" {
  value = aws_iam_role_policy_attachment.ecsTaskExecutionRole_ecsFargateExecRolePolicy_attachment.id
}