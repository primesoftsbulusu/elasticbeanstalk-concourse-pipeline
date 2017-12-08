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

#
# Get the build version
#
BUILD_VERSION_FILE="./demo-app-artifact/version"
if [ ! -f ${BUILD_VERSION_FILE} ]; then
    echo "${BUILD_VERSION_FILE} does not exists"
    exit 1
fi
BUILD_VERSION=$(cat ${BUILD_VERSION_FILE})

#
# Get the config version
#
CONFIG_VERSION_FILE="./demo-app-config/version"
if [ ! -f ${CONFIG_VERSION_FILE} ]; then
    echo "${CONFIG_VERSION_FILE} does not exists"
    exit 1
fi
CONFIG_VERSION=$(cat ${CONFIG_VERSION_FILE})

pushd ./bundle
cp ../demo-app-artifact/*.jar demo-app.jar
cp ../demo-app-config/*.yml application.yml
eb deploy ${ENVIRONMENT_NAME} --label "${BUILD_VERSION}:${CONFIG_VERSION}"
popd

