#!/usr/bin/env bash
# Install the build-context-model skill for Claude Code and Codex CLI.
# ./install.sh            → installs into ~/.claude/skills and ~/.codex/skills (whichever exist)
# ./install.sh --chatgpt  → copies the ready-to-paste pack (interview prompt + template) to the clipboard
set -euo pipefail

SKILL_NAME="build-context-model"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "--chatgpt" ]]; then
  PACK="$(sed -n '/^## The prompt/,/^## After the interview/p' "${SRC_DIR}/prompts/interview-prompt.md" | sed '1d;$d')

--- TEMPLATE (follow this structure) ---

$(cat "${SRC_DIR}/templates/context-model-template.md")"
  if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "${PACK}" | pbcopy
    echo "✅ ChatGPT pack copied to clipboard."
    echo "Paste it into a new ChatGPT chat (or a Project) and answer the interview."
  else
    printf '%s\n' "${PACK}"
  fi
  exit 0
fi

install_to() {
  local dest="$1/${SKILL_NAME}"
  mkdir -p "${dest}/templates" "${dest}/prompts"
  cp "${SRC_DIR}/SKILL.md" "${dest}/SKILL.md"
  cp "${SRC_DIR}/templates/context-model-template.md" "${dest}/templates/"
  cp "${SRC_DIR}/prompts/interview-prompt.md" "${dest}/prompts/"
  echo "✅ Installed: ${dest}"
}

installed=0
if [[ -d "${HOME}/.claude" ]]; then install_to "${HOME}/.claude/skills"; installed=1; fi
if [[ -d "${HOME}/.codex" ]]; then install_to "${HOME}/.codex/skills"; installed=1; fi

if [[ "${installed}" == "0" ]]; then
  echo "No ~/.claude or ~/.codex found. Install Claude Code or Codex CLI first,"
  echo "or use the no-install path: ./install.sh --chatgpt (works with any AI chat)."
  exit 1
fi

echo "Use it: /build-context-model  (or say: build my context model) — same command in Claude Code and Codex."
echo "ChatGPT / any chat: ./install.sh --chatgpt copies the paste-pack to your clipboard."
