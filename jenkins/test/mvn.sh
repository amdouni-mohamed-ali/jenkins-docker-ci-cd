#!/bin/bash

echo "***************************"
echo "**    Testing the code   **"
echo "***************************"

PROJECT_DIR=/home/salto/tutorials/jenkins/jenkins-pipeline-github
WORKSPACE=$PROJECT_DIR/jenkins_home/workspace/pipeline-jenkins-docker-ci-cd

docker run --rm  -v  $WORKSPACE/web-app:/app -v $PROJECT_DIR/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"
