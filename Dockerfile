ARG GO_IMAGE=rancher/hardened-build-base:v1.18.3b7
ARG REGISTRY=public.ecr.aws/b3e3i8k2

FROM ${GO_IMAGE} AS build

WORKDIR /src
COPY docker-credential-ecr-login /usr/bin/docker-credential-ecr-login
RUN mkdir /root/.docker
COPY config.json /root/.docker/config.json
COPY test /src/test
ENV REGISTRY=${REGISTRY} \
    METHOD=get \
    AWS_ECR_DISABLE_CACHE= \
    AWS_ECR_CACHE_DIR=/ecr/
ENTRYPOINT ["/bin/sh"]
#ENTRYPOINT ["/src/entrypoint.sh"]
CMD ["-c", "echo $REGISTRY | /usr/bin/docker-credential-ecr-login $METHOD"]