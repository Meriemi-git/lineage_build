#!/usr/bin/env bash
set -euo pipefail

API="${1:?missing api}"
PATCH_FILE="patches/api${API}/android_frameworks_base.patch"
REPO_PATH="frameworks/base"

echo "[*] Applying sucre patch for API ${API}"

if [ ! -d "${REPO_PATH}/.git" ]; then
  echo "[error] repo not found: ${REPO_PATH}"
  exit 1
fi

if [ ! -f "${PATCH_FILE}" ]; then
  echo "[error] patch not found: ${PATCH_FILE}"
  exit 1
fi

if git -C "${REPO_PATH}" apply --check --ignore-whitespace "${PATCH_FILE}" 2>/dev/null; then
  git -C "${REPO_PATH}" apply --ignore-whitespace --reject "${PATCH_FILE}"
  echo "[OK] patch applied"
  exit 0
fi

if git -C "${REPO_PATH}" apply --check --ignore-whitespace --reverse "${PATCH_FILE}" 2>/dev/null; then
  echo "[*] patch already applied"
  exit 0
fi

echo "[error] patch cannot be applied"
exit 1