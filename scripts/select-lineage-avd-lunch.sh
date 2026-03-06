#!/usr/bin/env bash
set -euo pipefail

if [ ! -d vendor/lineage/release/aconfig ]; then
  echo "vendor/lineage/release/aconfig not found" >&2
  exit 1
fi

REL="$(find vendor/lineage/release/aconfig -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tail -n1)"
TARGET="lineage_arm64-${REL}-userdebug"

echo "$TARGET"