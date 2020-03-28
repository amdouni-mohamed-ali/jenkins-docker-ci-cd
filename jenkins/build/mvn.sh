#!/bin/bash

echo "***************************"
echo "****** Building jar *******"
echo "***************************"

# This is our jenkins workspace. The directory where jenkins will download our git repository and run scripts
# this directory will be mounted to the jenkins container
WORKSPACE=/home/salto/tutorials/jenkins/jenkins-pipeline-github/jenkins_home/workspace/pipeline-jenkins-docker-ci-cd

# As we have mounted docker.sock the docker commands from the jenkins container will be executed in our local machine (docker server)
# As we will build the code downloaded by jenkins, we have to point to this new code which gonna be located in workspace directory of the jenkins container
# As this workspace is already mounted in the docker-compose file, we will just graph the path of this directory to WORKSPACE
docker run --rm  -v  $WORKSPACE/web-app:/app -v $PWD/.m2/:/root/.m2/ -w /app maven:3-alpine "$@"

# /app is workdirectory of the image

# $PWD/.m2/ is used to store the java dependencies and use it from other containers
# PWD is the current directory (/home/salto/tutorials/jenkins/jenkins-pipeline-github in my case)
# the second time we run this image we will not download the dependencies but we will use the .m2 volume

# -w /app : is used to specify the workdirectory

# we will run this script using ( mvn -B -DskipTests clean package ) as arguments
# these arguments will be passed as one argument using the $@ symbol
# mvn -B : -B is a shorthand for --batch-mode. It allows you to perform a release in a non-interactive way.
