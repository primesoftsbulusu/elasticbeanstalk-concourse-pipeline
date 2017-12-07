#!/bin/bash

set -e
set -u
set -x
set -o pipefail

pushd ./api-artifact

#
# Check that the application name & environment are set
#
if [ ! -n "${EB_APPLICATION}" ]; then
    echo "The EB_APPLICATION environment variable must be set"
    exit 1
fi

if [ ! -n "${EB_ENVIRONMENT}" ]; then
    echo "The EB_ENVIRONMENT environment variable must be set"
    exit 1
fi


#
# Get build version
#
BUILD_VERSION_FILE="./version"
if [ ! -f ${BUILD_VERSION_FILE} ]; then
    echo "${BUILD_VERSION_FILE} does not exists"
    exit 1
fi
VERSION=$(cat ${BUILD_VERSION_FILE})

eb init ${EB_APPLICATION} -r "${EB_REGION:-eu-west-1}"
eb deploy ${EB_ENVIRONMENT} --label "${VERSION}"

popd

