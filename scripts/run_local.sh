#!/usr/bin/env bash
set -euo pipefail

cat <<'TXT'
Local run (dry-run style):

1) Ensure env vars are set (.env + service .env files).
2) Run unit tests:
   - dotnet test services/app-inbound-ai-lambda/test/MyLambdaProject.Tests/MyLambdaProject.Tests.csproj
   - dotnet test services/app-process-openaichatgpt-lambda/test/MyLambdaProject.Tests/MyLambdaProject.Tests.csproj
   - dotnet test services/app-process-bestai-lambda/test/MyLambdaProject.Tests/MyLambdaProject.Tests.csproj
   - dotnet test services/app-respond-aiwhatsapp-lambda/test/MyLambdaProject.Tests/MyLambdaProject.Tests.csproj

3) To invoke handlers locally, use your preferred Lambda runtime emulator or invoke handler methods in tests.

Tip: for AWS dependencies, point to LocalStack or DynamoDB Local as needed.
TXT
