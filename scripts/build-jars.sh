#!/usr/bin/env bash
set -eo pipefail

API="${1:?missing api}"
VARIANT="${2:?missing variant}"

source build/envsetup.sh

try_lunch() {
  local target="$1"
  echo "[*] trying lunch target: $target"
  lunch "$target" >/tmp/lunch.log 2>&1 && return 0
  cat /tmp/lunch.log >&2
  return 1
}

try_lunch "aosp_arm64-userdebug" || \
try_lunch "aosp_x86_64-userdebug" || \
try_lunch "aosp_cf_x86_64_phone-userdebug" || {
  echo "[error] no working generic lunch target found"
  exit 1
}

TARGET_PRODUCT="$(get_build_var TARGET_PRODUCT)"
PRODUCT_OUT="$(get_build_var PRODUCT_OUT)"

echo "[*] selected TARGET_PRODUCT: $TARGET_PRODUCT"
echo "[*] PRODUCT_OUT: $PRODUCT_OUT"

m -j2 framework services

OUT_DIR="artifacts/api${API}/${VARIANT}"
mkdir -p "$OUT_DIR"

FRAMEWORK_JAR="$PRODUCT_OUT/system/framework/framework.jar"
SERVICES_JAR="$PRODUCT_OUT/system/framework/services.jar"

if [ ! -f "$FRAMEWORK_JAR" ]; then
  echo "[error] framework.jar not found: $FRAMEWORK_JAR"
  find out -name framework.jar | head -50
  exit 1
fi

if [ ! -f "$SERVICES_JAR" ]; then
  echo "[error] services.jar not found: $SERVICES_JAR"
  find out -name services.jar | head -50
  exit 1
fi

cp "$FRAMEWORK_JAR" "$OUT_DIR/"
cp "$SERVICES_JAR" "$OUT_DIR/"

sha256sum "$OUT_DIR/framework.jar" > "$OUT_DIR/framework.jar.sha256"
sha256sum "$OUT_DIR/services.jar" > "$OUT_DIR/services.jar.sha256"
