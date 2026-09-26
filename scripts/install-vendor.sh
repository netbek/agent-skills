#!/usr/bin/env bash
# Checkout pinned vendor submodules (checkout only, no stage/commit)
# Usage: install-vendor.sh (no args)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(readlink -f "${SCRIPT_DIR}/..")"

source "${SCRIPT_DIR}/common.sh"

reset_vendor() {
    git -C "$1" reset --hard HEAD
    git -C "$1" clean -fd
}

checkout_tag() {
    reset_vendor "$1"
    git -C "$1" fetch --tags origin
    git -C "$1" checkout --detach "tags/$2"
}

checkout_branch() {
    reset_vendor "$1"
    git -C "$1" fetch origin "$2"
    git -C "$1" checkout -B "$2" "origin/$2"
}

install_vendor() {
    cd "${ROOT_DIR}"
    echo "${YELLOW}Updating vendor submodules...${RESET}"
    git submodule sync --recursive
    git submodule update --init --recursive

    checkout_tag vendor/OpenSpec v1.13.2
    checkout_tag vendor/skills v1.2.3
    checkout_tag vendor/superpowers v6.4.2

    echo "${GREEN}Vendor submodules ready (checkout only, nothing staged).${RESET}"
}

install_vendor
