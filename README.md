# Drone prime publish
It's an ad-hoc image based on **docker-dind** image plus https://github.com/drone-plugins/drone-docker and https://github.com/awslabs/amazon-ecr-credential-helper .

Those additions are needed for:
- Being executed on drone pipelines
- Login into the public ECR

## Multiarch
This repo generate multiarch container images. 
Righ now are tested and working:
- AMD64
- ARM64
