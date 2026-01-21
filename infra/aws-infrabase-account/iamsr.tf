resource "aws_iam_user" "terraform" {
  name = "terraform"
}

resource "aws_iam_user" "github" {
  name = "github"
}

resource "aws_iam_policy" "iac_policy" {
  name        = "iac"
  description = "IAM policy for IaC"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*",
          "rds:*",
          "iam:*",
          "lambda:*",
          "dynamodb:*",
          "cloudwatch:*",
          "logs:*",
          "sns:*",
          "sqs:*",
          "autoscaling:*",
          "cloudformation:*",
          "sts:AssumeRole",
          "elasticloadbalancing:*",
          "ecr:*",
          "ecs:*",
          "eks:*",
          "route53:*",
          "cloudfront:*",
          "kms:*",
          "apigateway:*",
          "ssm:*",
          "secretsmanager:*",
          "elasticache:*",
          "cloudtrail:*",
          "codebuild:*",
          "codepipeline:*",
          "acm:*",
          "elasticbeanstalk:*",
          "application-autoscaling:*",
          "config:*",
          "organizations:ListAccounts",
          "organizations:ListOrganizationalUnitsForParent",
          "budgets:*",
          "cognito-idp:*",
          "cognito-identity:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "terraform_policy_attachment" {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.iac_policy.arn
}

resource "aws_iam_user_policy_attachment" "github_policy_attachment" {
  user       = aws_iam_user.github.name
  policy_arn = aws_iam_policy.iac_policy.arn
}