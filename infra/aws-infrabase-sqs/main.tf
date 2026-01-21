############################################

resource "aws_sqs_queue" "inbound_ai_process_sqs" {
  name                        = "inbound-ai-process-sqs.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.inbound_ai_process_ddlq.arn
    maxReceiveCount     = 2
  })
}

resource "aws_sqs_queue" "inbound_ai_process_ddlq" {
  name                        = "inbound-ai-process-ddlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############################################

resource "aws_sqs_queue" "app_process_bestai_lambda_erros_sqs" {
  name                        = "app-process-bestai-lambda-erros-sqs.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############################################

resource "aws_sqs_queue" "process_openaichatgpt_sqs" {
  name                        = "process-openaichatgpt-sqs.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.process_openaichatgpt_ddlq.arn
    maxReceiveCount     = 5
  })
}

resource "aws_sqs_queue" "process_openaichatgpt_ddlq" {
  name                        = "process-openaichatgpt-ddlq.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############################################  

resource "aws_sqs_queue" "process_openaichatgpt_lambda_erros_sqs" {
  name                        = "process-openaichatgpt-lambda-erros-sqs.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############################################  


resource "aws_sqs_queue" "respond_aiwhatsapp_erros_sqs" {
  name                        = "respond-aiwhatsapp-erros-sqs.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############################################  

