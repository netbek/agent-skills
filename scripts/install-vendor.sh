#!/usr/bin/env bash
# Init/update vendor submodules (pinned to tags via gitlinks)
# Usage: install-vendor.sh (no args)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(readlink -f "${SCRIPT_DIR}/..")"

# Init/update vendor submodules
install_vendor() {
    cd "${ROOT_DIR}"
    git submodule sync --recursive
    git submodule update --init --recursive --depth 1
}

install_vendor
