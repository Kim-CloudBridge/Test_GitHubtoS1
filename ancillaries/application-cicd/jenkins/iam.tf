resource "aws_iam_policy" "secrets_manager_get_secret_policy" {
  name        = local.secrets_manager_policy_name
  description = "Policy granting access to all secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attachements
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # AWS Managed Policy for SSM
}
resource "aws_iam_role_policy_attachment" "cloudwatchagent_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy" # AWS Managed Policy for CloudWatch Agent
}
resource "aws_iam_role_policy_attachment" "ssm_directory_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess" # AWS Managed Policy for SSM Directory Service
}
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = local.ssm_instance_profile_name
  role = aws_iam_role.ssm_role.name
}
resource "aws_iam_role_policy_attachment" "secrets_manager_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.secrets_manager_get_secret_policy.arn
}