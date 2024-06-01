#!/usr/bin/env bash
set -euo pipefail

BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CHART_DIR="${BASE_DIR}/../git-events-runner"
GENERATED_FILE=${WORKSPACE}/generated.txt
EXTRACTED_FILE=${WORKSPACE}/extracted.txt

trap "rm -f ${GENERATED_FILE} ${EXTRACTED_FILE}" EXIT

# generate default config
APP_VERSION=${LOCAL_APP_VERSION:-$(yq .appVersion ${CHART_DIR}/Chart.yaml)}
APP_IMAGE=${LOCAL_APP_IMAGE:-$(yq .image.repository ${CHART_DIR}/values.yaml)}

docker run --rm ${APP_IMAGE}:${APP_VERSION} config --helm-template > "${GENERATED_FILE}"

# Extract config from values.yaml
cat ${CHART_DIR}/values.yaml | yq .runtimeConfig > "${EXTRACTED_FILE}"

diff -c ${GENERATED_FILE} ${EXTRACTED_FILE}
