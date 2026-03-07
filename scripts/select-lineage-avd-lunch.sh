#!/usr/bin/env bash
set -eo pipefail

if [ ! -d vendor/lineage/release/aconfig ]; then
  echo "[error] vendor/lineage/release/aconfig not found" >&2
  exit 1
fi

REL="$(find vendor/lineage/release/aconfig -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tail -n1)"
echo "lineage_arm64-${REL}-userdebug"
