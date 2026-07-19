#!/usr/bin/env bash
# Install the context-model skill into Claude Code (user-level).
set -euo pipefail

SKILL_NAME="build-context-model"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.claude/skills/${SKILL_NAME}"

mkdir -p "${DEST_DIR}"
cp "${SRC_DIR}/SKILL.md" "${DEST_DIR}/SKILL.md"
mkdir -p "${DEST_DIR}/templates" "${DEST_DIR}/prompts"
cp "${SRC_DIR}/templates/context-model-template.md" "${DEST_DIR}/templates/"
cp "${SRC_DIR}/prompts/interview-prompt.md" "${DEST_DIR}/prompts/"

echo "✅ Installed: ${DEST_DIR}"
echo "Use it in Claude Code: /build-context-model  (or say: build my context model)"
