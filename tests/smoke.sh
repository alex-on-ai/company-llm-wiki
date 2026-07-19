#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/company-llm-wiki-smoke.XXXXXX")"
PROJECT_ROOT="${TEST_ROOT}/HighCraft"
GLOBAL_HOME="${TEST_ROOT}/home"

cleanup() {
  rm -rf -- "${TEST_ROOT}"
}
trap cleanup EXIT

mkdir -p "${PROJECT_ROOT}"
(
  cd "${PROJECT_ROOT}"
  "${REPO_ROOT}/install.sh" >/dev/null
)

for runtime in .claude .agents; do
  for skill in build-context-model process-meeting ingest file-tasks; do
    test -f "${PROJECT_ROOT}/${runtime}/skills/${skill}/SKILL.md"
  done
  test -f "${PROJECT_ROOT}/${runtime}/skills/build-context-model/llm-wiki.md"
  test ! -e "${PROJECT_ROOT}/${runtime}/skills/process-meeting/llm-wiki.md"
  test ! -e "${PROJECT_ROOT}/${runtime}/skills/ingest/llm-wiki.md"
  test ! -e "${PROJECT_ROOT}/${runtime}/skills/file-tasks/llm-wiki.md"
  test -f "${PROJECT_ROOT}/${runtime}/skills/build-context-model/templates/context-model-template.md"
  test -f "${PROJECT_ROOT}/${runtime}/skills/build-context-model/prompts/interview-prompt.md"
done

if [[ -d "${PROJECT_ROOT}/agent" ]]; then
  echo "Installer created an unrequested agent/ directory" >&2
  exit 1
fi

diff -qr "${PROJECT_ROOT}/.claude/skills" "${PROJECT_ROOT}/.agents/skills" >/dev/null

cmp "${REPO_ROOT}/skills/build-context-model/SKILL.md" "${PROJECT_ROOT}/.agents/skills/build-context-model/SKILL.md"
cmp "${REPO_ROOT}/skills/process-meeting/SKILL.md" "${PROJECT_ROOT}/.agents/skills/process-meeting/SKILL.md"
cmp "${REPO_ROOT}/skills/ingest/SKILL.md" "${PROJECT_ROOT}/.agents/skills/ingest/SKILL.md"
cmp "${REPO_ROOT}/skills/file-tasks/SKILL.md" "${PROJECT_ROOT}/.agents/skills/file-tasks/SKILL.md"

if [[ -d "${PROJECT_ROOT}/.codex/skills" ]]; then
  echo "Installer wrote to unsupported project-local .codex/skills" >&2
  exit 1
fi

mkdir -p "${GLOBAL_HOME}"
HOME="${GLOBAL_HOME}" "${REPO_ROOT}/install.sh" --global >/dev/null
for runtime in .claude .agents; do
  for skill in build-context-model process-meeting ingest file-tasks; do
    test -f "${GLOBAL_HOME}/${runtime}/skills/${skill}/SKILL.md"
  done
done
diff -qr "${GLOBAL_HOME}/.claude/skills" "${GLOBAL_HOME}/.agents/skills" >/dev/null
if [[ -d "${GLOBAL_HOME}/.codex/skills" ]]; then
  echo "Installer wrote to legacy global .codex/skills" >&2
  exit 1
fi

# The build skill owns the offline bootstrap copy. Downstream skills use the
# root-level artifact created by /build-context-model and carry no duplicates.
cmp "${REPO_ROOT}/llm-wiki.md" "${REPO_ROOT}/skills/build-context-model/llm-wiki.md"
for skill in build-context-model process-meeting ingest file-tasks; do
  test -f "${REPO_ROOT}/skills/${skill}/agents/openai.yaml"
done
test ! -e "${REPO_ROOT}/skills/process-meeting/llm-wiki.md"
test ! -e "${REPO_ROOT}/skills/ingest/llm-wiki.md"
test ! -e "${REPO_ROOT}/skills/file-tasks/llm-wiki.md"
cmp "${REPO_ROOT}/templates/context-model-template.md" "${REPO_ROOT}/skills/build-context-model/templates/context-model-template.md"
cmp "${REPO_ROOT}/prompts/interview-prompt.md" "${REPO_ROOT}/skills/build-context-model/prompts/interview-prompt.md"

# Claude Code plugin manifests parse and agree with each other.
python3 - "${REPO_ROOT}" << 'PYEOF'
import json, os, sys
root = sys.argv[1]
mp = json.load(open(os.path.join(root, ".claude-plugin", "marketplace.json")))
pl = json.load(open(os.path.join(root, ".claude-plugin", "plugin.json")))
assert mp["plugins"][0]["name"] == pl["name"] == "company-llm-wiki"
for rel in pl["skills"]:
    assert os.path.isfile(os.path.join(root, rel, "SKILL.md")), rel
print("plugin manifests ok")
PYEOF

grep -Fq 'the confirmed wiki root is exact' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'Create `context-model.md` now' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'gaps do not block /process-meeting or /ingest' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq '`[GAP]` markers never block ingest or meeting processing' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'Gaps never block processing' "${REPO_ROOT}/skills/process-meeting/SKILL.md"
grep -Fq 'Gaps never block filing' "${REPO_ROOT}/skills/ingest/SKILL.md"
grep -Fq 'No confirmation, no writes' "${REPO_ROOT}/skills/file-tasks/SKILL.md"
grep -Fq 'offer to file the team tasks with `/file-tasks`' "${REPO_ROOT}/skills/process-meeting/SKILL.md"
grep -Fq 'this command still files by default' "${REPO_ROOT}/skills/ingest/SKILL.md"
grep -Fq 'you MUST attempt a browser tool before involving the user' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'A personal LinkedIn profile is a normal source, not a mistake' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'Never create a public repo, and never push without this consent' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'push when a remote exists' "${REPO_ROOT}/skills/process-meeting/SKILL.md"
grep -Fq 'does not create another `your-company/` directory' "${REPO_ROOT}/README.md"
grep -Fq -- '--skill "*" --agent codex claude-code -y' "${REPO_ROOT}/README.md"
if grep -Fq -- 'npx skills@latest add alex-on-ai/company-llm-wiki --all' "${REPO_ROOT}/README.md"; then
  echo "README still recommends the all-agents install" >&2
  exit 1
fi
grep -Fq -- 'Never pass `-g` (these skills are folder-scoped) or `--all`' "${REPO_ROOT}/README.md"
test "$(sed -n '2p' "${REPO_ROOT}/templates/context-model-template.md")" = 'created: [YYYY-MM-DD]'

if grep -Fq '[company]/' "${REPO_ROOT}/skills/process-meeting/SKILL.md" "${REPO_ROOT}/skills/ingest/SKILL.md" "${REPO_ROOT}/skills/file-tasks/SKILL.md"; then
  echo "Nested company wrapper remains in a downstream skill" >&2
  exit 1
fi

echo "Smoke checks passed"
