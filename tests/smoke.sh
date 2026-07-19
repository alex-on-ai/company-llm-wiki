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
  for skill in build-context-model process-meeting ingest; do
    test -f "${PROJECT_ROOT}/${runtime}/skills/${skill}/SKILL.md"
    test -f "${PROJECT_ROOT}/${runtime}/skills/${skill}/llm-wiki.md"
  done
  test -f "${PROJECT_ROOT}/${runtime}/skills/build-context-model/templates/context-model-template.md"
  test -f "${PROJECT_ROOT}/${runtime}/skills/build-context-model/prompts/interview-prompt.md"
done

diff -qr "${PROJECT_ROOT}/.claude/skills" "${PROJECT_ROOT}/.agents/skills" >/dev/null

cmp "${REPO_ROOT}/skills/build-context-model/SKILL.md" "${PROJECT_ROOT}/.agents/skills/build-context-model/SKILL.md"
cmp "${REPO_ROOT}/skills/process-meeting/SKILL.md" "${PROJECT_ROOT}/.agents/skills/process-meeting/SKILL.md"
cmp "${REPO_ROOT}/skills/ingest/SKILL.md" "${PROJECT_ROOT}/.agents/skills/ingest/SKILL.md"

if [[ -d "${PROJECT_ROOT}/.codex/skills" ]]; then
  echo "Installer wrote to unsupported project-local .codex/skills" >&2
  exit 1
fi

mkdir -p "${GLOBAL_HOME}"
HOME="${GLOBAL_HOME}" "${REPO_ROOT}/install.sh" --global >/dev/null
for runtime in .claude .agents; do
  for skill in build-context-model process-meeting ingest; do
    test -f "${GLOBAL_HOME}/${runtime}/skills/${skill}/SKILL.md"
  done
done
diff -qr "${GLOBAL_HOME}/.claude/skills" "${GLOBAL_HOME}/.agents/skills" >/dev/null
if [[ -d "${GLOBAL_HOME}/.codex/skills" ]]; then
  echo "Installer wrote to legacy global .codex/skills" >&2
  exit 1
fi

grep -Fq 'the confirmed wiki root is exact' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'Create `context-model.md` now' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'gaps do not block /process-meeting or /ingest' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq '`[GAP]` markers never block ingest or meeting processing' "${REPO_ROOT}/skills/build-context-model/SKILL.md"
grep -Fq 'Gaps never block processing' "${REPO_ROOT}/skills/process-meeting/SKILL.md"
grep -Fq 'Gaps never block filing' "${REPO_ROOT}/skills/ingest/SKILL.md"
grep -Fq 'does not create another `your-company/` directory' "${REPO_ROOT}/README.md"
test "$(sed -n '2p' "${REPO_ROOT}/templates/context-model-template.md")" = 'created: [YYYY-MM-DD]'

if grep -Fq '[company]/' "${REPO_ROOT}/skills/process-meeting/SKILL.md" "${REPO_ROOT}/skills/ingest/SKILL.md"; then
  echo "Nested company wrapper remains in a downstream skill" >&2
  exit 1
fi

echo "Smoke checks passed"
