#!/usr/bin/env bash
set -euo pipefail

API="${1:?missing api}"
PATCH_DIR="patches/api${API}"

apply_one() {
  local repo_path="$1"
  local patch_name="$2"
  local patch_file="${PATCH_DIR}/${patch_name}"

  if [ ! -f "$patch_file" ]; then
    echo "[skip] missing patch: $patch_file"
    return 0
  fi

  if [ ! -d "${repo_path}/.git" ]; then
    echo "[error] repo not found: ${repo_path}"
    exit 1
  fi

  echo "[*] Applying ${patch_name} -> ${repo_path}"
  cp "$patch_file" "${repo_path}/"
  (
    cd "${repo_path}"
    git apply "${patch_name}" --ignore-whitespace --reject
  )
}

apply_one "frameworks/base" "android_frameworks_base.patch"
apply_one "system/sepolicy" "android_system_sepolicy.patch"
apply_one "packages/modules/DnsResolver" "android_packages_modules_dnsresolver.patch"

echo "[OK] patches applied for api${API}"