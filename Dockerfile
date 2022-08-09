ARG GO_IMAGE=rancher/hardened-build-base:v1.18.3b7
ARG DIND_IMAGE=docker:20.10.17-dind

FROM ${GO_IMAGE} AS build
ARG upstream=https://github.com/drone-plugins/drone-docker
ARG version=v20.12.0

WORKDIR /src
RUN git clone --depth=1 --branch=${version} ${upstream} .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GO111MODULE=on go build -v -a -tags netgo -o release/drone-docker ./cmd/drone-docker
RUN go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login@latest

FROM ${DIND_IMAGE}

WORKDIR /src/
COPY --from=build /src/release/drone-docker /bin/
COPY --from=build /go/bin/docker-credential-ecr-login /bin/ 
RUN mkdir /root/.docker
COPY config.json /root/.docker/config.json
COPY --chown=0:0 entrypoint.sh entrypoint.sh
RUN chmod +x /src/entrypoint.sh
ENV DOCKER_HOST=unix:///var/run/docker.sock
ENV METHOD=get \
    AWS_ECR_DISABLE_CACHE=True
ENTRYPOINT ["/bin/sh", "dockerd-entrypoint.sh", "/bin/drone-docker"]
