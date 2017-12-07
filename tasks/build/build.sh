#!/bin/bash

set -e
set -u
set -x
set -o pipefail

pushd demo-app-src/

mvn package -Dmaven.repo.local=.m2
cp target/*.jar ../build/*.jar

popd

ls -lha build/
