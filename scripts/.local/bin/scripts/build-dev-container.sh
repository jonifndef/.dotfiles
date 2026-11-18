#!/bin/bash

set -euo pipefail

cleanup()
{
    echo "Cleaning up..."

    if [ -n "${OG_IMAGE_NAME}" ]; then
        docker image rm "${OG_IMAGE_NAME}"
        docker image prune
    fi

    [ -d "/tmp/.dotfiles" ] && rm -rf "/tmp/.dotfiles"
    [ -d "/tmp/Busybox-static" ] && rm -rf "/tmp/Busybox-static"
}

trap 'cleanup' ERR EXIT

DOCKERFILE_PATH=""
IMAGE_NAME=""
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
        -n|--image-name)
          IMAGE_NAME="$2"
          shift
          shift
          ;;
        -h|--help)
          usage
          exit
          ;;
        *)
          echo "Unknown option $1"
          usage
          exit 1
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

    if [ $NUM -ge $INDEX ] || [ $NUM -lt 1 ]; then
        echo "Invalid choice"
        exit 1
    fi

    DOCKERFILE_PATH="${DOCKERFILES_ARR[(($NUM-1))]}"
}

set_dockerimage_name()
{
    if [ -z "${IMAGE_NAME}" ]; then
        WORKDIR="$(pwd)"
        if [ "$(basename ${WORKDIR})" = ".devcontainer" ]; then
            WORKDIR="$(dirname ${WORKDIR})"
        fi

        WORKDIR="$(basename ${WORKDIR})"

        echo "Image name is not set, setting to ${WORKDIR}_devcontainer"
        echo "Proceed? y/N"

        read USER_INPUT
        if [ "${USER_INPUT}" = "y" ]; then
            IMAGE_NAME="${WORKDIR}_devcontainer"
            return
        else
            exit 1
        fi
    fi
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

    git clone --branch master https://github.com/jonifndef/.dotfiles.git ${CONTEXT}/.dotfiles

    wget http://nixos.org/nix/install -O ${CONTEXT}/install.sh
}

build_overlay()
{
    docker build -t $IMAGE_NAME -f - "${CONTEXT}" <<-EOF
FROM $OG_IMAGE_NAME

USER root

RUN set -eux; \
  if command -v apt-get >/dev/null; then \
    apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xz-utils tar git passwd && rm -rf /var/lib/apt/lists/*; \
  elif command -v apk >/dev/null; then \
    apk add --no-cache ca-certificates curl xz tar git coreutils shadow; \
  elif command -v dnf >/dev/null; then \
    dnf install -y ca-certificates curl xz tar git shadow-utils && dnf clean all; \
  elif command -v microdnf >/dev/null; then \
    microdnf install -y ca-certificates curl xz tar git shadow-utils && microdnf clean all; \
  elif command -v yum >/dev/null; then \
    yum install -y ca-certificates curl xz tar git shadow-utils && yum clean all; \
  elif command -v pacman >/dev/null; then \
    pacman -Sy --noconfirm ca-certificates curl xz tar git shadow; \
  elif command -v zypper >/dev/null; then \
    zypper -n install ca-certificates curl xz tar git shadow; \
  else \
    echo "Unsupported base image: no known package manager" >&2; exit 1; \
  fi; \
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

#COPY Busybox-static/busybox_x86 /tmp/busybox
COPY --chown=${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} .dotfiles /tmp/.dotfiles
COPY install.sh /tmp/install.sh
RUN mv /tmp/.dotfiles /home/${USERNAME:-$DEV_USER}/
#RUN chmod 755 /tmp/busybox && \
#ln -s /tmp/busybox /tmp/tar && \
#ln -s /tmp/busybox /tmp/wget && \
#ln -s /tmp/busybox /tmp/xz && \
#ln -s /tmp/busybox /tmp/sha256sum && \
RUN chown -R ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /tmp && \
chown -R ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /home/${USERNAME:-$DEV_USER}

RUN mv /tmp/install.sh /home/${USERNAME:-$DEV_USER} && \
chown ${USERNAME:-$DEV_USER}:${USERNAME:-$DEV_USER} /home/${USERNAME:-$DEV_USER}/install.sh && \
chmod 755 /home/${USERNAME:-$DEV_USER}/install.sh

ENV USER=${USERNAME:-$DEV_USER}
ENV HOME=/home/${USERNAME:-$DEV_USER}
WORKDIR /home/${USERNAME:-$DEV_USER}

USER ${USERNAME:-$DEV_USER}

ENV PATH="\$PATH:/tmp/"
RUN mkdir -p .config && \
ln -s "../.dotfiles/home-manager/.config/home-manager" ".config/home-manager" && \
ln -s "../.dotfiles/nix/.config/nix" ".config/nix"

RUN ./install.sh
ENV PATH="/home/${USERNAME:-$DEV_USER}/.nix-profile/bin:${PATH}"
RUN echo "${USERNAME:-$DEV_USER}"
RUN nix run home-manager/master -- switch --flake .config/home-manager#${USERNAME:-$DEV_USER}-devcontainer --impure
EOF
}

main()
{
    parse_arguments "$@"
    set_dockerfile_path
    set_dockerimage_name
    build_og_image
    set_username
    download_dependencies
    build_overlay

    echo "SUCCESS"
}

main "$@"
