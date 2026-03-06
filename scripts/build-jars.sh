#!/usr/bin/env bash
set -euo pipefail

API="${1:?missing api}"
VARIANT="${2:?missing variant}"

source build/envsetup.sh

TARGET="$(bash scripts/select-lineage-avd-lunch.sh)"

echo "[*] lunch target: $TARGET"

lunch "$TARGET"

m -j4 framework services

PRODUCT_OUT="$(get_build_var PRODUCT_OUT)"

OUT_DIR="artifacts/api${API}/${VARIANT}"

mkdir -p "$OUT_DIR"

cp "$PRODUCT_OUT/system/framework/framework.jar" "$OUT_DIR/"
cp "$PRODUCT_OUT/system/framework/services.jar" "$OUT_DIR/"

sha256sum "$OUT_DIR/framework.jar" > "$OUT_DIR/framework.jar.sha256"
sha256sum "$OUT_DIR/services.jar" > "$OUT_DIR/services.jar.sha256"