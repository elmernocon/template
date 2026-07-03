#!/bin/sh
# Fail on TEMP markers that are expired or lack a parseable date
# (code/temporary-code-is-marked-and-expires).
# Marker form: TEMP(YYYY-MM-DD): <reason, what to do at expiry>
set -eu

# Run from the repository root: the exclude pathspecs below are
# root-relative, and outside a repository this fails loudly instead of
# passing on a scan that never ran.
top=$(git rev-parse --show-toplevel)
cd "$top"

today=$(date +%Y-%m-%d)

# --untracked scans not-yet-committed files too; .gitignore (and with
# it .worktrees/, per ai-behavior/one-agent-one-branch-one-worktree) still
# applies. -F matches the marker literally, immune to grep.patternType
# configuration. The excluded paths quote the marker in order to document
# the convention — they are not temporary code.
status=0
matches=$(git grep -IFn --untracked "TEMP(" -- \
    ':!AGENTS.md' \
    ':!README.md' \
    ':!docs/decisions' \
    ':!scripts/check-temp-markers.sh' \
) || status=$?

case $status in
    0) ;;                 # markers found: validate them below
    1) exit 0 ;;          # no markers anywhere
    *) exit "$status" ;;  # git grep itself failed: never pass on a broken scan
esac

printf '%s\n' "$matches" | awk -v today="$today" '
    {
        if (match($0, /TEMP\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)/)) {
            date = substr($0, RSTART + 5, 10)
            if (date < today) {
                printf "expired TEMP marker (%s): %s\n", date, $0
                bad = 1
            }
        } else {
            printf "TEMP marker without parseable date: %s\n", $0
            bad = 1
        }
    }
    END { exit bad }
'
