#!/bin/bash

MYSTR=$1

echo "${MYSTR}" | sed -e 's/ - / /g' -e 's/ /-/g' | tr '[:upper:]' '[:lower:]'
