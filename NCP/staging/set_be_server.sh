#!/bin/bash

#0. source env file
source .env

#1. docker login
docker login \
    $NCP_CONTAINER_REGISTRY \
    --username $NCP_ACCESS_KEY \
    --password $NCP_SECRET_KEY


#2. docker pull
docker pull $IMAGE_TAG

#3. docker run
docker run -p 8000:8000 -d \
    -v ~/.aws:/root/.aws:ro \
    --env-file .env \
    --name lion-app \
    $IMAGE_TAG

#4. check docker
docker ps