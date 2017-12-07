#!/bin/sh

set -e

fly -t demo set-pipeline -n -p demo-app -c pipeline.yml -l credentials.yml

find . -name "*.sh" -exec chmod +x {} \;

git add .
git commit -m "${1:--}" && git push

