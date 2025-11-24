#!/bin/bash

set -euo pipefail

DOCKERFILE_PATH=""
OG_IMAGE_NAME=""

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

cleanup()
{
    if [ -n "${OG_IMAGE_NAME}" ]; then
        docker image rm "${OG_IMAGE_NAME}"
        docker system prune
    fi
}

set_username()
{
    # One weakness here, what if there is a group with id 1000, without a user with id 1000?
    USERNAME=$(docker run --rm "${OG_IMAGE_NAME}" sh -c 'grep "1000:1000" /etc/passwd | cut -d: -f1')
}

build_overlay()
{
    CONTEXT=$(mktemp -d)
    DEV_USER="dev"

    docker build -t devcontainer_jonas -f - "${CONTEXT}" <<-EOF
        FROM $OG_IMAGE_NAME

        RUN set -eux \
            if [ -z $USERNAME ]; then \
                if usermod -v > /dev/null 2>&1; then \
                    # We are prolly in arch-/debian-/fedoraland \
                    groupadd -g 1000 $DEV_USER; \
                    useradd -m -u 1000 -g 1000 -s /bin/sh $DEV_USER; \
                else \
                    # We are prolly in alpine-with-just-busybox-land \
                    addgroup -g 1000 $DEV_USER; \
                    useradd -D -u 1000 -G $DEV_USER $DEV_USER; \
                fi
EOF
}

main()
{
    parse_arguments "$@"
    set_dockerfile_path
    build_og_image
    set_username
    build_overlay
    cleanup

    echo "SUCCESS"
}

main "$@"
