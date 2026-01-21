# Security

## Local configuration
- Copy `.env.example` to `.env` and fill values.
- For service-specific settings, use each service's `.env.example`.
- Never commit real secrets or keys.

## GitHub Actions
- Store secrets in GitHub Actions Secrets (e.g., `OPENAI_API_KEY`).
- Reference secrets in workflows with `${{ secrets.NAME }}`.

## AWS SSM / Secrets Manager (optional)
- Default approach: store sensitive values in SSM Parameter Store.
- Secrets Manager is optional for rotation-heavy workloads.
- Grant each Lambda least-privilege access to read only its required secrets.
- Map secret values into environment variables at deploy time.

## Scanners
- Gitleaks and TruffleHog reports are stored in `/reports` and ignored by git.
- Findings are resolved by replacing secrets with env references.
