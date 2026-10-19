#!/usr/bin/env bash
set -euo pipefail

# Usage: fetch-issues.sh <project-key>
# REST API fallback to retrieve SonarQube issues when MCP is unavailable.
# Saves full JSON to a temp file; prints a summary to stdout.
# Never prints or logs the token.

PROJECT_KEY="${1:?Usage: fetch-issues.sh <project-key>}"

if [ -z "${SONAR_TOKEN:-}" ] || [ -z "${SONAR_HOST_URL:-}" ]; then
  echo "ERROR: SONAR_TOKEN and SONAR_HOST_URL must be set"
  exit 1
fi

TMPFILE=$(mktemp "${TMPDIR:-/tmp}/sonar-issues-XXXXXX.json")
PAGE=1
TOTAL=0
FETCHED=0

while true; do
  RESPONSE=$(curl -sf -u "$SONAR_TOKEN:" \
    "$SONAR_HOST_URL/api/issues/search?projectKeys=${PROJECT_KEY}&statuses=OPEN,CONFIRMED,REOPENED&ps=500&p=${PAGE}") || {
    echo "ERROR: API request failed on page $PAGE"
    exit 1
  }

  if [ "$PAGE" -eq 1 ]; then
    echo "$RESPONSE" > "$TMPFILE"
    TOTAL=$(echo "$RESPONSE" | grep -o '"total":[0-9]*' | head -1 | cut -d: -f2)
    echo "Total issues: ${TOTAL:-0}"
  else
    echo "$RESPONSE" >> "$TMPFILE"
  fi

  PAGE_ISSUES=$(echo "$RESPONSE" | grep -o '"key":"' | wc -l)
  FETCHED=$((FETCHED + PAGE_ISSUES))

  if [ "$PAGE_ISSUES" -lt 500 ] || [ "$FETCHED" -ge "${TOTAL:-0}" ]; then
    break
  fi
  PAGE=$((PAGE + 1))
done

echo "Fetched: $FETCHED"
echo "JSON saved to: $TMPFILE"

# Summary counts by severity
for sev in BLOCKER CRITICAL MAJOR MINOR INFO; do
  COUNT=$(grep -o "\"severity\":\"${sev}\"" "$TMPFILE" | wc -l)
  echo "  $sev: $COUNT"
done

HOTSPOTS=$(grep -o '"type":"SECURITY_HOTSPOT"' "$TMPFILE" | wc -l)
echo "  Security Hotspots: $HOTSPOTS"
exit 0
