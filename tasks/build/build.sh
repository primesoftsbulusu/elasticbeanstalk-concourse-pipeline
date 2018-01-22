#!/bin/bash

set -euxo pipefail

pushd demo-app-src/

mvn package -Dmaven.repo.local=.m2
cp target/*.jar ../build/demo-app.jar

popd

ls -lha build/
