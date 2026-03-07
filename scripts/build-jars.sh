#!/usr/bin/env bash
set -eo pipefail

API="${1:?missing api}"
VARIANT="${2:?missing variant}"

source build/envsetup.sh

REL="$(find vendor/lineage/release/aconfig -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | tail -n1)"
TARGET="lineage_arm64-${REL}-userdebug"

echo "[*] lunch target: $TARGET"

lunch "$TARGET"

m -j2 framework services

PRODUCT_OUT="$(get_build_var PRODUCT_OUT)"
OUT_DIR="artifacts/api${API}/${VARIANT}"

mkdir -p "$OUT_DIR"

FRAMEWORK_JAR="$PRODUCT_OUT/system/framework/framework.jar"
SERVICES_JAR="$PRODUCT_OUT/system/framework/services.jar"

if [ ! -f "$FRAMEWORK_JAR" ]; then
  echo "[error] framework.jar not found: $FRAMEWORK_JAR"
  find out -name framework.jar | head -20
  exit 1
fi

if [ ! -f "$SERVICES_JAR" ]; then
  echo "[error] services.jar not found: $SERVICES_JAR"
  find out -name services.jar | head -20
  exit 1
fi

cp "$FRAMEWORK_JAR" "$OUT_DIR/"
cp "$SERVICES_JAR" "$OUT_DIR/"

sha256sum "$OUT_DIR/framework.jar" > "$OUT_DIR/framework.jar.sha256"
sha256sum "$OUT_DIR/services.jar" > "$OUT_DIR/services.jar.sha256"
