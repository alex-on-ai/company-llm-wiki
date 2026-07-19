#!/usr/bin/env bash
# Install the company-llm-wiki skills (build-context-model, process-meeting, ingest)
# for Claude Code and Codex.
# ./install.sh                   → installs globally: ~/.claude/skills and ~/.codex/skills (whichever exist)
# ./install.sh --local           → installs into ./.claude/skills of the current project only
# ./install.sh --chatgpt         → copies the interview paste-pack (prompt + template) to the clipboard
# ./install.sh --chatgpt ingest  → copies the ingest prompt to the clipboard
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "--chatgpt" ]]; then
  if [[ "${2:-}" == "ingest" ]]; then
    PACK="$(cat "${SRC_DIR}/prompts/ingest-prompt.md")"
    LABEL="Ingest pack"
  else
    PACK="$(sed -n '/^## The prompt/,/^## After the interview/p' "${SRC_DIR}/prompts/interview-prompt.md" | sed '1d;$d')

--- TEMPLATE (follow this structure) ---

$(cat "${SRC_DIR}/templates/context-model-template.md")"
    LABEL="Interview pack"
  fi
  if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "${PACK}" | pbcopy
    echo "✅ ${LABEL} copied to clipboard - paste into any AI chat."
  else
    printf '%s\n' "${PACK}"
  fi
  exit 0
fi

install_skill() {
  local name="$1" dest_root="$2"
  local dest="${dest_root}/${name}"
  mkdir -p "${dest}"
  cp -R "${SRC_DIR}/skills/${name}/." "${dest}/"
  cp "${SRC_DIR}/llm-wiki.md" "${dest}/llm-wiki.md"
  if [[ "${name}" == "build-context-model" ]]; then
    mkdir -p "${dest}/templates" "${dest}/prompts"
    cp "${SRC_DIR}/templates/context-model-template.md" "${dest}/templates/"
    cp "${SRC_DIR}/prompts/interview-prompt.md" "${dest}/prompts/"
  fi
  echo "✅ Installed: ${dest}"
}

installed=0
if [[ "${1:-}" == "--local" ]]; then
  for name in build-context-model process-meeting ingest; do
    install_skill "${name}" "${PWD}/.claude/skills"
  done
  installed=1
  echo "Installed into this project only (./.claude/skills). Run the agent from this folder."
else
  for root in "${HOME}/.claude" "${HOME}/.codex"; do
    if [[ -d "${root}" ]]; then
      for name in build-context-model process-meeting ingest; do
        install_skill "${name}" "${root}/skills"
      done
      installed=1
    fi
  done
fi

if [[ "${installed}" == "0" ]]; then
  echo "No ~/.claude or ~/.codex found. Install Claude Code or Codex first,"
  echo "use ./install.sh --local from your project folder,"
  echo "or the no-install path: ./install.sh --chatgpt (works with any AI chat)."
  exit 1
fi

echo ""
echo "Once     : /build-context-model  - build your company's context model"
echo "Meetings : /process-meeting      - transcript in raw/ → wiki pages + tasks + spec + drafts"
echo "Anything : /ingest               - file any material into the wiki"
echo "ChatGPT  : ./install.sh --chatgpt          (interview pack → clipboard)"
echo "           ./install.sh --chatgpt ingest   (ingest prompt → clipboard)"
