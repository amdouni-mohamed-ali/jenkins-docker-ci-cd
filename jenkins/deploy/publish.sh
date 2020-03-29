#!/bin/bash

# This script will be transfered to the deploy machine and placed in the /tmp directory
# in the first 3 lines we gonna extract and export the environment variables transfered from jenkins to the /tmp/.auth file

export IMAGE=$(sed -n '1p' /tmp/.auth)
export TAG=$(sed -n '2p' /tmp/.auth)
export PASS=$(sed -n '3p' /tmp/.auth)

# Log into the private repository
echo "Log into docker hub" && \
docker login -u mouhamedali -p $PASS && \

# stop already running container
echo "Stopping the already running container (if exists)"

EXIST=$(docker container ls | grep app)
if [ -z "$EXIST" ]
then
      echo "the container is already stopped"
else
      echo "Stopping the container"  && docker stop app
fi

# Log into the private repository
echo "Run the new version of the web application" && \
cd ~ && docker run -d -p 80:8070 --rm --name app mouhamedali/$IMAGE:$TAG
