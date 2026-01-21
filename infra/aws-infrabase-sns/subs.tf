resource "aws_sns_topic_subscription" "app_respond_aiwhatsapp_lambda" {
  topic_arn = aws_sns_topic.respond_ai_global_sns.arn
  protocol  = "lambda"
  endpoint  = data.aws_lambda_function.app_respond_aiwhatsapp_lambda.arn

  filter_policy = jsonencode({
    app = ["whatsapp"]
  })
}