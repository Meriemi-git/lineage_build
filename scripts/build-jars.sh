#!/usr/bin/env bash
set -euo pipefail

API="${1:?missing api}"
VARIANT="${2:?missing variant}"

source build/envsetup.sh

TARGET="$(bash scripts/select-lineage-avd-lunch.sh)"
echo "[*] Lunch target: ${TARGET}"
lunch "${TARGET}"

m -j4 framework services

PRODUCT_OUT="$(get_build_var PRODUCT_OUT)"
OUT_DIR="artifacts/api${API}/${VARIANT}"

mkdir -p "${OUT_DIR}"

FRAMEWORK_JAR="${PRODUCT_OUT}/system/framework/framework.jar"
SERVICES_JAR="${PRODUCT_OUT}/system/framework/services.jar"

if [ ! -f "${FRAMEWORK_JAR}" ]; then
  echo "[error] framework.jar not found"
  find out -name framework.jar | head -20
  exit 1
fi

if [ ! -f "${SERVICES_JAR}" ]; then
  echo "[error] services.jar not found"
  find out -name services.jar | head -20
  exit 1
fi

cp -v "${FRAMEWORK_JAR}" "${OUT_DIR}/framework.jar"
cp -v "${SERVICES_JAR}" "${OUT_DIR}/services.jar"

sha256sum "${OUT_DIR}/framework.jar" > "${OUT_DIR}/framework.jar.sha256"
sha256sum "${OUT_DIR}/services.jar" > "${OUT_DIR}/services.jar.sha256"

cat > "${OUT_DIR}/build-info.txt" <<EOF
api=${API}
variant=${VARIANT}
target=${TARGET}
product_out=${PRODUCT_OUT}
framework_jar=${FRAMEWORK_JAR}
services_jar=${SERVICES_JAR}
EOF