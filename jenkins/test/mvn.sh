#!/bin/bash

echo "***************************"
echo "**    Testing the code   **"
echo "***************************"

WORKSPACE=/home/salto/tutorials/jenkins/jenkins-pipeline-github/jenkins_home/workspace/pipeline-jenkins-docker-ci-cd

docker run --rm  -v  $WORKSPACE/java-app:/app -v $PWD/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
