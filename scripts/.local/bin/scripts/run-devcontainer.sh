#!/bin/bash

# Usage example:
# run-devcontainer my-image ubuntu

IMAGE=$1

CONTAINER_HOME=$(
  docker run --rm --entrypoint sh "${IMAGE}" \
    -c 'getent passwd 1000 | cut -d: -f6'
)

docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v ${SSH_AUTH_SOCK}:/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
    -e DEVCONTAINER_NAME=${IMAGE} \
    --network host \
    -v ${HOME}/.config/nvim:${CONTAINER_HOME}/.config/nvim:ro \
    -v "${HOME}/.gitconfig:${CONTAINER_HOME}/.gitconfig:ro" \
    -v $(pwd):/workspace \
    -w /workspace \
    ${IMAGE} \
    zsh

# Another way to run:
#
#docker run --rm -it \
#    -e LOCAL_USER_ID=`id -u $USER` \
#    -v ${SSH_AUTH_SOCK}:/tmp/ssh-agent \
#    -v `pwd`:/workspace \
#    --ulimit nofile=262144:262144 \
#    ${IMAGE}
