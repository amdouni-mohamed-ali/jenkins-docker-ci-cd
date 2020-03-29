#!/bin/bash

PROJECT_DIR=/home/salto/tutorials/jenkins/jenkins-pipeline-github
WORKSPACE=$PROJECT_DIR/jenkins_home/workspace/pipeline-jenkins-docker-ci-cd

# In this file we gonna transfer the environment variables to the prod-user machine via FTP (we gonna create the /tmp/.auth file that contains the env variables)
echo jenkins-tutorial > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $DOCKER_PASS >> /tmp/.auth

# This is the path of the private key to connect to the deploy machine
AWS_PROD_KEY=$WORKSPACE/jenkins/deploy/aws-vm-prod-user.pem
AWS_PROD_VM_IP=prod-user@ec2-3-17-81-229.us-east-2.compute.amazonaws.com

# Transfer the environment variables to be used in the deploy machine to run the image
scp -i $AWS_PROD_KEY /tmp/.auth $AWS_PROD_VM_IP:/tmp/.auth

# Transfer and run the run script (this script contains the docker run command) 
scp -i $AWS_PROD_KEY ./jenkins/deploy/publish.sh $AWS_PROD_VM_IP:/tmp/publish.sh
ssh -i $AWS_PROD_KEY $AWS_PROD_VM_IP "/tmp/publish.sh"
