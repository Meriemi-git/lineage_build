#!/usr/bin/env bash
set -euo pipefail

REL="$(find vendor/lineage/release/aconfig -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tail -n1)"

TARGET="lineage_arm64-${REL}-userdebug"

echo "$TARGET"