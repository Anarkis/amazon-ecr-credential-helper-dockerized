#!/bin/bash
echo $REGISTRY | /usr/bin/docker-credential-ecr-login $METHOD 
docker build -f test/Dockerfile -t public.ecr.aws/b3e3i8k2/test:v3 .
docker push public.ecr.aws/b3e3i8k2/test:v3