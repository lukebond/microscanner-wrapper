#!/bin/bash
set -eux

MICROSCANNER_TOKEN="${MICROSCANNER_TOKEN:-}"
DOCKER_IMAGE="${1:-}"
TEMP_IMAGE_TAG=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | tr '[:upper:]' '[:lower:]')
set -o pipefail

main() {
  [[ -z ${MICROSCANNER_TOKEN} ]] && { print_usage; exit 1; }
  [[ -z ${DOCKER_IMAGE} ]] && { print_usage; exit 1; }

  DOCKERFILE=$(mktemp -p . Dockerfile.XXXXXXXXXX)
  trap cleanup_dockerfile EXIT

  cat >${DOCKERFILE} <<EOL
FROM ${DOCKER_IMAGE}
ADD https://get.aquasec.com/microscanner .
RUN chmod +x microscanner
RUN ./microscanner ${MICROSCANNER_TOKEN}
EOL
  cat ${DOCKERFILE}
  docker build -t ${TEMP_IMAGE_TAG} -f ${DOCKERFILE} .
  docker image rm ${TEMP_IMAGE_TAG}
}

print_usage() {
  echo "Usage: MICROSCANNER_TOKEN=xxxxxxxxxxxxxxxx ./scan.sh DOCKER_IMAGE"
}

cleanup_dockerfile() {
  rm "${DOCKERFILE}"
}

main
