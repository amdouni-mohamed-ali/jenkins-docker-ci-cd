#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

# This is my git hub repo mouhamedali/jenkins-docker-ci-cd
IMAGE="jenkins-docker-ci-cd"

echo "** Logging in to the docker hub ***"
echo "$DOCKER_PASS" | docker login --username mouhamedali --password-stdin

echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG mouhamedali/$IMAGE:$BUILD_TAG

echo "*** Pushing image ***"
docker push mouhamedali/$IMAGE:$BUILD_TAG