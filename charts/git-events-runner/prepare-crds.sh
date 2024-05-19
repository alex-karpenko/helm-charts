#!/usr/bin/env bash
set -euo pipefail

BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CHART_DIR="${BASE_DIR}/../git-events-runner"
BUNDLE_FILE=${BASE_DIR}/../crds.yaml
CRDS_DIR=${CHART_DIR}/crds

# generate CRD bundle from the latest binary
APP_VERSION=${LOCAL_APP_VERSION:-$(yq .appVersion ${CHART_DIR}/Chart.yaml)}
APP_IMAGE=${LOCAL_APP_IMAGE:-$(yq .image.repository ${CHART_DIR}/values.yaml)}

docker run --rm ${APP_IMAGE}:${APP_VERSION} crds > ${BUNDLE_FILE}

# Split the generated bundle yaml file to inject control flags
mkdir -p ${CRDS_DIR}
yq e -Ns "\"${CRDS_DIR}/\" + .spec.names.singular" ${BUNDLE_FILE}

rm ${BUNDLE_FILE}
