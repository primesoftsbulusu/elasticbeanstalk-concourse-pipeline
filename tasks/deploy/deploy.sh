#!/bin/bash

set -euxo pipefail

# Check that the application environment is set
if [ ! -n "${ENVIRONMENT_NAME}" ]; then
    echo "The ENVIRONMENT_NAME environment variable must be set"
    exit 1
fi
if [ ! -n "${APPLICATION_NAME}" ]; then
    echo "The APPLICATION_NAME environment variable must be set"
    exit 1
fi

#
# Get the build version
#
BUILD_VERSION_FILE="./demo-app-artifact/version"
if [ ! -f ${BUILD_VERSION_FILE} ]; then
    echo "${BUILD_VERSION_FILE} does not exists"
    exit 1
fi
BUILD_VERSION=$(cat ${BUILD_VERSION_FILE})

mkdir ./bundle
pushd ./bundle

cp ../demo-app-artifact/*.jar demo-app.jar

eb init ${APPLICATION_NAME} \
    -p "java-8" \
    --region "us-east-1"


# Create the environment if it doesn't exist
if ! eb list | grep -w "${ENVIRONMENT_NAME}"; then
    echo "Creating the environment ${ENVIRONMENT_NAME}"

    eb create ${ENVIRONMENT_NAME} \
        --cname "${CNAME:-$ENVIRONMENT_NAME}" \
        --single \
        --instance_type "t2.micro" \
        --envvars "SERVER_PORT=5000"
fi

eb deploy ${ENVIRONMENT_NAME} --label "${BUILD_VERSION}"

popd

