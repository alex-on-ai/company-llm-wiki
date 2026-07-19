#!/usr/bin/env bash
# Install the company-llm-wiki skills (build-context-model, process-meeting,
# ingest, file-tasks) for Claude Code and Codex.
# Run it FROM YOUR PROJECT FOLDER (the folder where the company wiki will live):
# ../path/to/install.sh          → installs into ./.claude/skills and ./.agents/skills of the current folder (default)
# ../path/to/install.sh --global → installs machine-wide: ~/.claude/skills and ~/.agents/skills
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
  rm -rf -- "${dest}"
  mkdir -p "${dest}"
  cp -R "${SRC_DIR}/skills/${name}/." "${dest}/"
  echo "✅ Installed: ${dest}"
}

if [[ "${1:-}" == "--global" ]]; then
  for dest in "${HOME}/.claude/skills" "${HOME}/.agents/skills"; do
    for name in build-context-model process-meeting ingest file-tasks; do
      install_skill "${name}" "${dest}"
    done
  done
  echo "Installed machine-wide (~/.claude/skills + ~/.agents/skills)."
else
  if [[ "${PWD}" == "${SRC_DIR}" ]]; then
    echo "You are inside the kit repo itself. cd into your project folder first:"
    echo "  cd path/to/your-company-folder && ${SRC_DIR}/install.sh"
    echo "Or install machine-wide from anywhere: ./install.sh --global"
    exit 1
  fi
  for dest in "${PWD}/.claude/skills" "${PWD}/.agents/skills"; do
    for name in build-context-model process-meeting ingest file-tasks; do
      install_skill "${name}" "${dest}"
    done
  done
  echo "Installed into this project (./.claude/skills + ./.agents/skills). Run your agent from this folder."
  echo "This current folder is the wiki root; /build-context-model writes ./context-model.md here and does not create a nested company folder."
  echo "Machine-wide instead: ./install.sh --global"
fi

echo ""
echo "Once     : /build-context-model  - build your company's context model"
echo "Meetings : /process-meeting      - transcript in raw/ → wiki pages + tasks + spec + drafts"
echo "Anything : /ingest               - file any material into the wiki"
echo "Tracker  : /file-tasks           - create the team tasks in your connected tracker"
echo "ChatGPT  : ./install.sh --chatgpt          (interview pack → clipboard)"
echo "           ./install.sh --chatgpt ingest   (ingest prompt → clipboard)"
echo ""
echo "→ Restart your agent session (skills load at startup), then start with /build-context-model."
