#!/bin/bash

DOCKERFILE_PATH=""
DOCKERFILES=$(find . -iname "*Dockerfile*")
NL='
'
case $DOCKERFILES in
    *"$NL"*)
        echo "The workspace contains more than one Dockerfile. Which one would you like to build?"
        ;;
          *)
        echo "just one line"
        ;;
esac

#INDEX=1
#
#DOCKERFILES_ARR=()
#
#while IFS= read -r FILE; do
#    echo "${INDEX}. ${FILE}"
#    INDEX=$((INDEX + 1))
#    DOCKERFILES_ARR+=("${FILE}")
#done <<< "$DOCKERFILES"
#
#
#echo ""
#
#for i in "${DOCKERFILES_ARR[@]}"; do
#    echo "$i"
#done
