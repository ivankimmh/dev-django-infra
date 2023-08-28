#!/bin/bash

#0. source env file
source .env

# 1. pull db image
docker pull postgres:13

# 2. run container
docker run -d -p 5432:5432 --name db \
  -v postgres_data:/var/lib/postgresql/data \
  --env-file .env \
  postgres:13

# 3. check docker
docker ps