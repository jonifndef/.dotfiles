#!/bin/bash

# Usage example:
# run-devcontainer my-image ubuntu

IMAGE=$1
USER=$2

docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v ${SSH_AUTH_SOCK}:/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
    --network host \
    -v ${HOME}/.config/nvim:/home/${USER}/.config/nvim \
    -v $(pwd):/workspace \
    -w /workspace \
    ${IMAGE} \
    zsh || bash

# Another way to run:
#
#docker run --rm -it \
#    -e LOCAL_USER_ID=`id -u $USER` \
#    -v ${SSH_AUTH_SOCK}:/tmp/ssh-agent \
#    -v `pwd`:/workspace \
#    --ulimit nofile=262144:262144 \
#    ${IMAGE}
