#!/bin/bash

set -euo pipefail

cleanup()
{
    echo "Cleaning up..."

    if [ -n "${OG_IMAGE_NAME}" ]; then
        docker image rm "${OG_IMAGE_NAME}"
        docker system prune
    fi

    [ -d "/tmp/.dotfiles" ] && rm -rf "/tmp/.dotfiles"
    [ -d "/tmp/Busybox-static" ] && rm -rf "/tmp/Busybox-static"
    [ -d "${CONTEXT}" ] && rm -rf "${CONTEXT}"
}

trap 'cleanup' ERR EXIT

DOCKERFILE_PATH=""
OG_IMAGE_NAME=""
NIX_TARBALL_URL="https://releases.nixos.org/nix/nix-2.32.4/nix-2.32.4-x86_64-linux.tar.xz"
NIX_TARBALL=""
DEV_USER="dev"

usage()
{
    echo "Usage:"
    echo "Stand in a project root that contains a .devcontainer directory with one or several Dockerfiles in it"
    echo "Or simply pass a path to a Dockerfile directly, like so:"
    echo "    build-dev-container -p|--dockerfile-path ./my/path/to/Dockerfile"
}

parse_arguments()
{
    while [[ $# -gt 0 ]]; do
      case $1 in
        -p|--dockerfile-path)
          DOCKERFILE_PATH="$2"
          shift
          shift
          ;;
        -h|--help)
          usage
          exit
          shift
          shift
          ;;
        *)
          echo "Unknown option $1"
          usage
          exit 1
          shift
          ;;
      esac
    done
}

set_dockerfile_path()
{
    if [ -n "${DOCKERFILE_PATH}" ]; then
        return
    fi

    DOCKERFILES=$(find . -iname "*Dockerfile*")
NL='
'
    case $DOCKERFILES in
        *"$NL"*)
            echo "The workspace contains more than one Dockerfile. Which one would you like to build?"
            ;;
              *)
            DOCKERFILE_PATH="$DOCKERFILES"
            return
            ;;
    esac

    INDEX=1
    DOCKERFILES_ARR=()

    while IFS= read -r FILE; do
        echo "${INDEX}. ${FILE}"
        INDEX=$((INDEX + 1))
        DOCKERFILES_ARR+=("${FILE}")
    done <<< "$DOCKERFILES"

    read -p "Enter number: " NUM

    if [ $NUM -gt $INDEX ] || [ $NUM -lt 1 ]; then
        echo "Invalid choice"
        exit 1
    fi

    DOCKERFILE_PATH="${DOCKERFILES_ARR[(($NUM-1))]}"
}

build_og_image()
{
    OG_IMAGE_NAME="devcontainer_$(uuidgen)"
    docker build -t "${OG_IMAGE_NAME}" -f "${DOCKERFILE_PATH}" .
}

set_username()
{
    # One weakness here, what if there is a group with id 1000, without a user with id 1000?
    USERNAME=$(docker run --rm "${OG_IMAGE_NAME}" sh -c 'grep "1000:1000" /etc/passwd | cut -d: -f1')
}

download_dependencies()
{
    CONTEXT=$(mktemp -d)
    git clone https://github.com/jonifndef/Busybox-static.git ${CONTEXT}/Busybox-static
    git clone --branch ubuntu-cab https://github.com/jonifndef/.dotfiles.git ${CONTEXT}/.dotfiles
    curl -L "${NIX_TARBALL_URL}" -o "${CONTEXT}/nix.tar.xz"
    curl -L https://curl.se/ca/cacert.pem -o ${CONTEXT}/ca-certificates.crt
}

build_overlay()
{
    docker build -t creone_devcontainer_jonas -f - "${CONTEXT}" <<-EOF
FROM $OG_IMAGE_NAME
USER root

RUN set -eux; \
if [ "${USERNAME}x" = "x" ]; then \
if command -v usermod > /dev/null 2>&1; then \
groupadd -g 1000 $DEV_USER; \
useradd -m -u 1000 -g 1000 -s /bin/sh $DEV_USER; \
else \
addgroup --gid 1000 $DEV_USER; \
adduser -D -u 1000 -G $DEV_USER $DEV_USER; \
mkdir -p /home/$DEV_USER; \
chown -R $DEV_USER:$DEV_USER /home/$DEV_USER; \
fi; \
fi

RUN mkdir -p /nix && chmod 755 /nix && chown -R ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /nix

COPY Busybox-static/busybox_x86 /tmp/busybox
COPY .dotfiles /tmp/.dotfiles
COPY nix.tar.xz /tmp/nix.tar.xz
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

RUN mv /tmp/.dotfiles /home/${USERNAME:-$DEV_USER}/

RUN chmod 755 /tmp/busybox && \
ln -s /tmp/busybox /tmp/tar && \
ln -s /tmp/busybox /tmp/wget && \
ln -s /tmp/busybox /tmp/xz && \
ln -s /tmp/busybox /tmp/sha256sum && \
chown -R ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /tmp && \
chown -R ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /home/${USERNAME:-$DEV_USER}

RUN mv /tmp/nix.tar.xz /home/${USERNAME:-$DEV_USER} && \
chown ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /home/${USERNAME:-$DEV_USER}/nix.tar.xz && \
chmod 755 /home/${USERNAME:-$DEV_USER}/nix.tar.xz

RUN if [ -f /etc/alpine-release ]; then \
apk add --no-cache coreutils xz; \
fi

ENV USER=${USERNAME:-$DEV_USER}
ENV HOME=/home/${USERNAME:-$DEV_USER}
WORKDIR /home/${USERNAME:-$DEV_USER}

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
ENV HTTPS_CA_CERT=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR=/etc/ssl/certs

USER ${USERNAME:-$DEV_USER}

ENV PATH="\$PATH:/tmp/"
RUN mkdir -p .config && \
ln -s "../.dotfiles/home-manager/.config/home-manager" ".config/home-manager" && \
ln -s "../.dotfiles/nix/.config/nix" ".config/nix"

RUN tar -xf nix.tar.xz && ./nix-*/install --no-daemon

ENV PATH="/home/${USERNAME:-$DEV_USER}/.nix-profile/bin:${PATH}"
RUN nix run home-manager/master -- switch --flake .config/home-manager#${USERNAME:-$DEV_USER} --impure
EOF
}

main()
{
    parse_arguments "$@"
    set_dockerfile_path
    build_og_image
    set_username
    download_dependencies
    build_overlay

    echo "SUCCESS"
}

main "$@"
