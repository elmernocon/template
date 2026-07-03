#!/bin/sh
# Tests for scripts/check-temp-markers.sh
# (code/temporary-code-is-marked-and-expires).
set -eu

checker=$(cd "$(dirname "$0")/.." && pwd)/scripts/check-temp-markers.sh
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The marker token is spliced so this test file passes the check itself.
m='TEMP''('

fail() { echo "FAIL: $1" >&2; exit 1; }

new_repo() {
    rm -rf "$tmp/repo"
    mkdir "$tmp/repo"
    git -C "$tmp/repo" init -q
}

# A future-dated marker passes.
new_repo
printf '# %s2999-01-01): remove when 2999 rolls around\n' "$m" > "$tmp/repo/a.txt"
(cd "$tmp/repo" && "$checker") || fail "future-dated marker should pass"

# An expired marker fails.
new_repo
printf '# %s2020-01-01): long gone\n' "$m" > "$tmp/repo/a.txt"
if (cd "$tmp/repo" && "$checker") >/dev/null; then
    fail "expired marker should fail"
fi

# A dateless marker fails.
new_repo
printf '# %ssomeday): no date\n' "$m" > "$tmp/repo/a.txt"
if (cd "$tmp/repo" && "$checker") >/dev/null; then
    fail "dateless marker should fail"
fi

# A marker-free repository passes.
new_repo
printf 'nothing to see\n' > "$tmp/repo/a.txt"
(cd "$tmp/repo" && "$checker") || fail "marker-free repo should pass"

# A marker dated today passes — expiry means the date has passed.
new_repo
printf '# %s%s): due today, not expired\n' "$m" "$(date +%Y-%m-%d)" \
    > "$tmp/repo/a.txt"
(cd "$tmp/repo" && "$checker") || fail "marker dated today should pass"

# The marker is matched literally, immune to grep.patternType config.
new_repo
printf '# %s2020-01-01): long gone\n' "$m" > "$tmp/repo/a.txt"
git -C "$tmp/repo" config grep.patternType extended
if (cd "$tmp/repo" && "$checker") >/dev/null; then
    fail "expired marker should fail under grep.patternType=extended"
fi

# The whole repository is scanned regardless of the invocation
# directory.
new_repo
mkdir "$tmp/repo/sub"
printf '# %s2020-01-01): long gone\n' "$m" > "$tmp/repo/a.txt"
if (cd "$tmp/repo/sub" && "$checker") >/dev/null; then
    fail "checker run from a subdirectory should still scan the whole repo"
fi

# Excluded paths are repository-root-relative, not cwd-relative.
new_repo
mkdir "$tmp/repo/sub"
printf '# %s2020-01-01): quotes the convention\n' "$m" \
    > "$tmp/repo/AGENTS.md"
(cd "$tmp/repo/sub" && "$checker") \
    || fail "excluded paths should apply when run from a subdirectory"

# Outside a git repository the checker fails loudly instead of
# passing on a scan that never ran.
rm -rf "$tmp/notrepo"
mkdir "$tmp/notrepo"
if (cd "$tmp/notrepo" && "$checker") 2>/dev/null; then
    fail "running outside a git repository should fail"
fi

echo "ok: check-temp-markers"
