#!/bin/bash

# In this file we gonna transfer the environment variables to the prod-user machine via FTP (we gonna create the /tmp/.auth file that contains the env variables)
echo jenkins-docker-ci-cd > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $DOCKER_PASS >> /tmp/.auth

# This is the path of the private key to connect to the deploy machine
AWS_PROD_KEY=./jenkins/deploy/aws-vm-prod-user.pem
AWS_PROD_VM_IP=prod-user@ec2-3-17-81-229.us-east-2.compute.amazonaws.com

# make the private key only readeable
echo "Change the private key permissions" && \
    chmod 400 $AWS_PROD_KEY && \

# Transfer the environment variables to be used in the deploy machine to run the image
echo "Transfer the .auth file" && \
scp -i $AWS_PROD_KEY /tmp/.auth $AWS_PROD_VM_IP:/tmp/.auth  && \

# Transfer and run the run script (this script contains the docker run command) 
echo "Transfer the publish.sh script file" && \
scp -i $AWS_PROD_KEY ./jenkins/deploy/publish.sh $AWS_PROD_VM_IP:/tmp/publish.sh  && \

echo "Execute the publish.sh script" && \
ssh -i $AWS_PROD_KEY $AWS_PROD_VM_IP "/tmp/publish.sh"
