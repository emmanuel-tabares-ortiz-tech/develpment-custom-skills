#!/usr/bin/env bash
set -euo pipefail

# Runs sonar-scanner with quality-gate wait.
# Token is passed via CLI arg only — never written to properties files.
# Never echoes or logs the token.

if [ -z "${SONAR_TOKEN:-}" ] || [ -z "${SONAR_HOST_URL:-}" ]; then
  echo "ERROR: SONAR_TOKEN and SONAR_HOST_URL must be set"
  exit 1
fi

# Detect available scanner
if command -v sonar-scanner >/dev/null 2>&1; then
  exec sonar-scanner \
    -Dsonar.token="$SONAR_TOKEN" \
    -Dsonar.host.url="$SONAR_HOST_URL" \
    -Dsonar.qualitygate.wait=true
elif [ -f mvnw ] || command -v mvn >/dev/null 2>&1; then
  MVN="${PWD}/mvnw"
  [ -x "$MVN" ] || MVN="mvn"
  exec "$MVN" sonar:sonar \
    -Dsonar.token="$SONAR_TOKEN" \
    -Dsonar.host.url="$SONAR_HOST_URL" \
    -Dsonar.qualitygate.wait=true
elif [ -f gradlew ] || command -v gradle >/dev/null 2>&1; then
  GRD="${PWD}/gradlew"
  [ -x "$GRD" ] || GRD="gradle"
  exec "$GRD" sonarqube \
    -Dsonar.token="$SONAR_TOKEN" \
    -Dsonar.host.url="$SONAR_HOST_URL" \
    -Dsonar.qualitygate.wait=true
elif command -v npx >/dev/null 2>&1; then
  exec npx sonarqube-scanner \
    -Dsonar.token="$SONAR_TOKEN" \
    -Dsonar.host.url="$SONAR_HOST_URL" \
    -Dsonar.qualitygate.wait=true
elif command -v dotnet >/dev/null 2>&1; then
  exec dotnet sonarscanner begin \
    /d:sonar.token="$SONAR_TOKEN" \
    /d:sonar.host.url="$SONAR_HOST_URL" \
    /d:sonar.qualitygate.wait=true
else
  echo "ERROR: No scanner found (sonar-scanner, mvn, gradle, npx, dotnet)"
  exit 1
fi
