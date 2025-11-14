#!/bin/bash

DOCKERFILE_PATH=""

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

main()
{
    parse_arguments "$@"
    if [ -z "${DOCKERFILE_PATH}" ]; then
        set_dockerfile_path
    fi
    echo "DOCKERFILE_PATH is set to: ${DOCKERFILE_PATH}"
}

main "$@"
