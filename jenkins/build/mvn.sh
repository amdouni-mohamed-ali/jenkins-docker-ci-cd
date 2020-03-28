#!/bin/bash

echo "***************************"
echo "****** Building jar *******"
echo "***************************"

# This is our jenkins workspace. The directory where jenkins will download our git repository and run scripts
WORKSPACE=/home/jenkins/jenkins-data/jenkins_home/workspace/pipeline-jenkins-docker-ci-cd

docker run --rm  -v  $WORKSPACE/web-app:/app -v /home/jenkins/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"

# /app is workdirectory of the image

# /home/jenkins/.m2/ is used to store the java dependencies and use it from other containers
# the second time we run this image we will not download the dependencies but we will use the .m2 volume

# -w /app : is used to specify the workdirectory

# we will run this script using ( mvn -B -DskipTests clean package ) as arguments
# these arguments will be passed as one argument using the $@ symbol
# mvn -B : -B is a shorthand for --batch-mode. It allows you to perform a release in a non-interactive way.
