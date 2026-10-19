#!/usr/bin/env bash
# Siempre termina en 0: cualquier fallo aquí abortaría toda la skill
v() { "$@" 2>/dev/null || echo "NOT FOUND"; }

echo "- Fecha: $(date +%F)"
echo "- SO: $(uname -s)"
for e in podman docker nerdctl; do
  echo "- $e: $(command -v "$e" || echo 'NOT FOUND')"
done
echo "- SONAR_HOST_URL: ${SONAR_HOST_URL:-NOT SET}"
echo "- SONAR_TOKEN: $([ -n "${SONAR_TOKEN:-}" ] && echo SET || echo 'NOT SET')"
echo "- Rama: $(v git branch --show-current)"
echo "- Repo root: $(v git rev-parse --show-toplevel)"
echo "- sonar-project.properties:"
if [ -f sonar-project.properties ]; then
  grep -viE 'token|login|password' sonar-project.properties
else
  echo "  NOT FOUND"
fi
echo "- MCP registrados:"
claude mcp list 2>/dev/null || echo "  NOT FOUND"
exit 0
