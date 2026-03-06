#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${REPO_ROOT}/config/apis.env"

log() {
  echo "[*] $*"
}

die() {
  echo "[!] $*" >&2
  exit 1
}

branch_for_api() {
  case "$1" in
    33) echo "${API33_BRANCH}" ;;
    34) echo "${API34_BRANCH}" ;;
    35) echo "${API35_BRANCH}" ;;
    36) echo "${API36_BRANCH}" ;;
    *) die "API inconnue: $1" ;;
  esac
}