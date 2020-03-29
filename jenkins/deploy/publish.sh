#!/bin/bash

# This script will be transfered to the deploy machine and placed in the /tmp directory
# in the first 3 lines we gonna extract and export the environment variables transfered from jenkins to the /tmp/.auth file

export IMAGE=$(sed -n '1p' /tmp/.auth)
export TAG=$(sed -n '2p' /tmp/.auth)
export PASS=$(sed -n '3p' /tmp/.auth)

# Log into the private repository
docker login -u mouhamedali -p $PASS

# Log into the private repository
cd ~ && docker run --rm --name app $IMAGE:$TAG
