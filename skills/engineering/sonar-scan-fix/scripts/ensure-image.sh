#!/usr/bin/env bash
set -euo pipefail

# Usage: ensure-image.sh <engine>
# Checks if docker.io/sonarsource/sonarqube-mcp exists locally; pulls if missing.
# Prints: EXISTS, PULLED, or PULL_FAILED followed by stderr on failure.

ENGINE="${1:?Usage: ensure-image.sh <podman|docker|nerdctl>}"
IMAGE="docker.io/sonarsource/sonarqube-mcp"

if "$ENGINE" image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "EXISTS"
  exit 0
fi

if pull_output=$("$ENGINE" pull "$IMAGE" 2>&1); then
  echo "PULLED"
else
  echo "PULL_FAILED"
  echo "$pull_output"
fi
exit 0
