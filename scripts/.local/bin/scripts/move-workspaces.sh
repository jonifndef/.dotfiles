#!/bin/bash

for ws in 2 4 6 8 10; do
    i3-msg "[workspace=$ws]" move workspace to output primary > /dev/null 2>&1
done
