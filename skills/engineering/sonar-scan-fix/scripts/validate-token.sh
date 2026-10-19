#!/usr/bin/env bash
set -euo pipefail

# Validates SONAR_TOKEN against SONAR_HOST_URL.
# Prints exactly one word: VALID, INVALID, NETWORK_ERROR, CERT_ERROR, or HTTP_<code>.
# Never prints the token.

if [ -z "${SONAR_HOST_URL:-}" ] || [ -z "${SONAR_TOKEN:-}" ]; then
  echo "MISSING_ENV"
  exit 0
fi

http_code=$(curl -sf -o /dev/null -w '%{http_code}' \
  -u "$SONAR_TOKEN:" \
  "$SONAR_HOST_URL/api/authentication/validate" 2>/dev/null) && rc=0 || rc=$?

if [ "$rc" -ne 0 ]; then
  # Distinguish network vs certificate errors
  curl_err=$(curl -sf -u "$SONAR_TOKEN:" \
    "$SONAR_HOST_URL/api/authentication/validate" 2>&1) || true
  case "$curl_err" in
    *certificate*|*SSL*|*TLS*) echo "CERT_ERROR" ;;
    *) echo "NETWORK_ERROR" ;;
  esac
  exit 0
fi

# Re-fetch with body to check "valid":true
body=$(curl -sf -u "$SONAR_TOKEN:" \
  "$SONAR_HOST_URL/api/authentication/validate" 2>/dev/null) || true

case "$body" in
  *'"valid":true'*) echo "VALID" ;;
  *'"valid":false'*) echo "INVALID" ;;
  *) echo "HTTP_${http_code}" ;;
esac
exit 0
