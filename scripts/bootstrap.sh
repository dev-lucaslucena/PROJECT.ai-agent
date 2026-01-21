#!/usr/bin/env bash
set -euo pipefail

root_env=".env"
if [ ! -f "$root_env" ] && [ -f ".env.example" ]; then
  cp .env.example "$root_env"
  echo "Created $root_env from .env.example"
fi

while IFS= read -r env_example; do
  env_dir="$(dirname "$env_example")"
  env_target="$env_dir/.env"
  if [ ! -f "$env_target" ]; then
    cp "$env_example" "$env_target"
    echo "Created $env_target from $env_example"
  fi
done < <(find services -name '.env.example' -print)

echo "Bootstrap complete. Fill in any empty values before running services."
