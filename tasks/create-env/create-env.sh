#!/bin/bash

set -euxo pipefail

# Check that the environment variables are set
if [ ! -n "${APPLICATION_NAME}" ]; then
    echo "The APPLICATION_NAME environment variable must be set"
    exit 1
fi

if [ ! -n "${ENVIRONMENT_NAME}" ]; then
    echo "The ENVIRONMENT_NAME environment variable must be set"
    exit 1
fi


pushd ./bundle

eb init ${APPLICATION_NAME} \
    -p "java-8" \
    --region "us-east-1"

# Do not create the environment if it already exists
if eb list | grep -w "${ENVIRONMENT_NAME}"; then
    echo "The environment already exists"
    exit 0
fi

echo "Creating the environment ${ENVIRONMENT_NAME}"

eb create ${ENVIRONMENT_NAME} \
    --cname "${CNAME:-$ENVIRONMENT_NAME}" \
    --single \
    --instance_type "t2.micro" \
    --envvars "SERVER_PORT=5000" \
    --sample

popd

