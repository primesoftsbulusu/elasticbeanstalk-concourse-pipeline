#!/bin/bash

set -e
set -u
set -x
set -o pipefail

VERSION=$(cat ./api-version/version)

pushd api-src/


#
# Extract short git ref
#
if [ ! -f ".git/HEAD" ]; then
    echo ".git/HEAD does not exists"
    exit 1
fi

GITREV=$(cat .git/HEAD | cut -c-7)

if [[ ! ${GITREV} =~ ^[0-9a-fA-F]{7}$ ]]; then
    echo "Invalid git ref: ${GITREV}"
    exit 1
fi


#
# Compose version
#
DATE=$(date '+%Y%m%d%H%M%S')
BUILD_VERSION=${VERSION}-${DATE}-${GITREV}


#
# build jar
#
pushd sesserver
mvn versions:set -DnewVersion=${BUILD_VERSION} -Dmaven.repo.local=../.m2
mvn verify -Dmaven.repo.local=../.m2 -Dgit.sha=${GITREV} -Dversion=${VERSION}
popd


#
# create output files
#
cp sesserver/target/*.jar ../build/ses-api.${BUILD_VERSION}.jar
echo ${BUILD_VERSION} > ../build/version

popd

ls -lha build/
