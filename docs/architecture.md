# Architecture

## Components
- WhatsApp inbound API (API Gateway + Lambda)
- Inbound queue (SQS with DLQ)
- Processing Lambda (AI request + enrichment)
- AI provider integration (OpenAI via env-configured API key)
- Persistence layer (DynamoDB)
- Response Lambda (SNS fan-out and response webhook)
- Supporting infra: IAM, VPC endpoints as needed, CloudWatch
 
## Diagrams
- `docs/diagrams/inbound-flow.svg`
- `docs/diagrams/process-layer.svg`
- `docs/diagrams/respond-flow.svg`
- `docs/diagrams/network-defaults.svg`
- `docs/diagrams/lambda-vpc-patterns.svg`

## End-to-end flow
1. WhatsApp webhook hits API Gateway.
2. Authorizer Lambda validates the request.
3. Inbound Lambda validates payload and enqueues message to SQS.
4. Processing Lambda consumes the queue, calls AI, persists results.
5. Processing Lambda publishes to SNS.
6. Response Lambda delivers the response back to WhatsApp.

## Reliability and scaling
- Queue buffering: SQS absorbs bursts and smooths traffic.
- Retries + DLQ: failed messages retry with backoff and land in DLQ for triage.
- Idempotency: processing Lambdas use a requestId/messageId to guard against duplicates.
- Timeouts + backoff: short Lambda timeouts with exponential backoff on external calls.
- Concurrency limits: reserved concurrency protects downstream dependencies.
- Multi-AZ: serverless services are multi-AZ by default; queues and databases scale horizontally.

## Security model
- Auth: API Gateway authorizer Lambda (and Cognito where applicable).
- Secrets: never in code; provided via environment variables or SSM Parameter Store (Secrets Manager optional).
- Least privilege IAM for each Lambda and infra module.

## Observability
- Structured logs with correlation IDs (requestId across queue/lambda hops).
- CloudWatch metrics/alarms for queue depth, error rate, and Lambda duration.
- Dashboards for throughput, latency, and DLQ counts.
