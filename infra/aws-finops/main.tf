resource "aws_sns_topic" "budget_alert" {
  name = "budget-alert-topic"
}

resource "aws_sns_topic_subscription" "budget_alert_email" {
  topic_arn = aws_sns_topic.budget_alert.arn
  protocol  = "email"
  endpoint  = "lucas@lucaslucena.com"
}

resource "aws_budgets_budget" "monthly_budget" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 100.0
    threshold_type      = "PERCENTAGE"
    subscriber_email_addresses = [
      "lucas@lucaslucena.com" 
    ]
    subscriber_sns_topic_arns = [
      aws_sns_topic.budget_alert.arn
    ]
  }
}
