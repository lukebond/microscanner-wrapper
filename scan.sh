#!/bin/bash
set -euo pipefail

MICROSCANNER_TOKEN="${MICROSCANNER_TOKEN:-}"
DOCKER_IMAGE="${1:-}"
TEMP_IMAGE_TAG=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n 1 | tr '[:upper:]' '[:lower:]' || true)

main() {
  local MICROSCANNER_BINARY MICROSCANNER_SOURCE
  [[ -z ${MICROSCANNER_TOKEN} ]] && { print_usage; exit 1; }
  [[ -z ${DOCKER_IMAGE} ]] && { print_usage; exit 1; }

  trap cleanup EXIT

  TEMP_DIR=$(mktemp -d)
  cd "${TEMP_DIR}"

  MICROSCANNER_SOURCE="https://get.aquasec.com/microscanner"
  if MICROSCANNER_BINARY=$(command -v microscanner); then
    printf "Using local "
    microscanner --version

    cp "${MICROSCANNER_BINARY}" ./microscanner
    MICROSCANNER_SOURCE="microscanner"
    echo
  fi

  cat <<EOL | docker build -t ${TEMP_IMAGE_TAG} -f - .
FROM ${DOCKER_IMAGE}

RUN if [ ! -d /etc/ssl/certs/ ]; then \
  PACKAGE_MANAGER=\$(basename \$(command which apk apt yum false 2>/dev/null | head -n1)); \
  if [ \${PACKAGE_MANAGER} = apk ]; then \
    COMMAND='apk --update add'; \
  elif [ \${PACKAGE_MANAGER} = apt ]; then \
    COMMAND='apt update && apt install --no-install-recommends -y'; \
  elif [ \${PACKAGE_MANAGER} = yum ]; then \
    COMMAND='yum install -y'; \
  else \
    echo '/etc/ssl/certs/ not found and package manager not apk, apt, or yum. Aborting' >&2; \
    exit 1; \
  fi; \
  eval \${COMMAND} ca-certificates; \
fi

ADD ${MICROSCANNER_SOURCE} .
RUN chmod +x microscanner \
  && ./microscanner --version \
  && ./microscanner ${MICROSCANNER_TOKEN}
EOL
}

print_usage() {
  echo "Usage: MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh DOCKER_IMAGE"
}

cleanup() {
  docker image rm --force "${TEMP_IMAGE_TAG}" || true
  rm -rf "${TEMP_DIR}" || true
}

main
