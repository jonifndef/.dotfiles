#!/bin/bash

read INPUT
echo ${INPUT} | sed "s|'|\"|g; s|None|null|g; s|False|false|g; s|True|true|g"
