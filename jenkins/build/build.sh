#!/bin/bash

# Copy the new jar to the build location
cp -f web-app/target/*.jar jenkins/build/

echo "****************************"
echo "** Building Docker Image ***"
echo "****************************"

# When the ‘–no-cache’ option is passed to ‘Docker build…’, then that build will always start from scratch, writing a new image to the file system even if nothing in the Dockerfile has changed. This is guaranteed to not reuse stale results, but will always take the maximum amount of time.

cd jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
