#!/usr/bin/env bash
# Bumps the package version across manifests for a GitHub-only release.
# Usage: bump-version.sh [major|minor|patch] (e.g. bump-version.sh patch)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(readlink -f "${SCRIPT_DIR}/..")"

VALID_BUMP="major minor patch"

die() {
    echo "error: $1" >&2
    exit 1
}

usage() {
    echo "Usage: $0 [major|minor|patch]"
    echo "Example: $0 patch"
}

[ "${1:-}" = "--help" ] && {
    usage
    exit 0
}

BUMP="${1:-}"
if [ -z "${BUMP}" ]; then
    usage >&2
    die "bump type is required"
fi
if ! echo "${VALID_BUMP}" | grep -qw "${BUMP}"; then
    die "invalid bump '${BUMP}', must be one of: ${VALID_BUMP}"
fi

cd "${ROOT_DIR}"

pnpm version "${BUMP}"

git add package.json
git commit -m "chore(release): ${NEW}"
