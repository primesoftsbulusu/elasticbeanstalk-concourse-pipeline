#!/bin/bash

set -e
set -u
set -x
set -o pipefail

# Check that the application environment is set
if [ ! -n "${ENVIRONMENT_NAME}" ]; then
    echo "The ENVIRONMENT_NAME environment variable must be set"
    exit 1
fi

pushd ./pipeline-src/eb-config

# Do not create the environment if it already exists
if eb list | grep -w "${ENVIRONMENT_NAME}"; then
    echo "The environment already exists"
    exit 0
fi

eb init
eb create "${ENVIRONMENT_NAME}" \
    --cname "${CNAME:-$ENVIRONMENT_NAME}" \
    --cfg "${ENVIRONMENT_NAME}" \
    --sample

popd

