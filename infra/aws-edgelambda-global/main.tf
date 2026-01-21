resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_name}-lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["edgelambda.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_name}-lambda_policy"
  description = "IAM policy for ${var.lambda_name} Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParameterHistory"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn

  depends_on = [
    aws_iam_role.lambda_role,
    aws_iam_policy.lambda_policy
  ]
}

resource "aws_lambda_permission" "apigtw_lambda" {
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "edgelambda.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

resource "aws_lambda_function" "lambda" {
  s3_bucket        = var.repo_name
  s3_key           = "lambda.zip"
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  memory_size      = 128
  timeout          = 5
  source_code_hash = data.aws_s3_object.lambda_zip.etag
  publish          = true

  logging_config {
    log_group  = aws_cloudwatch_log_group.lambda_log_group.name
    log_format = "JSON"
  }

  depends_on = [
    aws_iam_role.lambda_role,
    aws_iam_policy.lambda_policy,
    aws_iam_role_policy_attachment.lambda_policy
  ]
}