#!/bin/sh
echo $REGISTRY | /bin/docker-credential-ecr-login $METHOD > /dev/null
dockerd-entrypoint.sh /bin/drone-docker