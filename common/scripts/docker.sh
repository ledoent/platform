#!/bin/bash
# Supports minified mode for resource-constrained dev machines:
#   rush docker --minified   or   rush docker:min

MINIFIED=false
for arg in "$@"; do
  if [ "$arg" = "--minified" ]; then
    MINIFIED=true
    break
  fi
done

if [ "$MINIFIED" = true ]; then
  echo "Building minified docker images (excluding optional services)..."
  npx turbo run docker:build \
    --filter=@hcengineering/pod-server \
    --filter=@hcengineering/pod-front \
    --filter=@hcengineering/prod \
    --filter=@hcengineering/pod-account \
    --filter=@hcengineering/pod-workspace \
    --filter=@hcengineering/pod-collaborator \
    --filter=@hcengineering/tool \
    --filter=@hcengineering/pod-analytics-collector \
    --filter=@hcengineering/rekoni-service \
    --filter=@hcengineering/pod-datalake \
    --filter=@hcengineering/pod-export \
    --filter=@hcengineering/pod-media \
    --filter=@hcengineering/pod-external
else
  npx turbo run docker:build \
    --filter=@hcengineering/pod-server \
    --filter=@hcengineering/pod-front \
    --filter=@hcengineering/prod \
    --filter=@hcengineering/pod-account \
    --filter=@hcengineering/pod-workspace \
    --filter=@hcengineering/pod-collaborator \
    --filter=@hcengineering/tool \
    --filter=@hcengineering/pod-print \
    --filter=@hcengineering/pod-sign \
    --filter=@hcengineering/pod-analytics-collector \
    --filter=@hcengineering/rekoni-service \
    --filter=@hcengineering/pod-ai-bot \
    --filter=@hcengineering/import-tool \
    --filter=@hcengineering/pod-stats \
    --filter=@hcengineering/pod-fulltext \
    --filter=@hcengineering/pod-love \
    --filter=@hcengineering/pod-mail \
    --filter=@hcengineering/pod-datalake \
    --filter=@hcengineering/pod-mail-worker \
    --filter=@hcengineering/pod-export \
    --filter=@hcengineering/pod-media \
    --filter=@hcengineering/pod-preview \
    --filter=@hcengineering/pod-link-preview \
    --filter=@hcengineering/pod-external \
    --filter=@hcengineering/pod-backup \
    --filter=@hcengineering/backup-api-pod \
    --filter=@hcengineering/pod-billing \
    --filter=@hcengineering/pod-process \
    --filter=@hcengineering/pod-rating \
    --filter=@hcengineering/pod-payment \
    --filter=@hcengineering/pod-worker
fi
