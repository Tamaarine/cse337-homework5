#!/bin/bash

# Constants; add more if necessary
WRONG_ARGS_MSG="data file or output file missing"
FILE_NOT_FOUND_MSG="file not found"
MORE_ARGS_MSG="Exactly 2 arguments required"

# Checking args
if [ $# -gt 2 ] || [ $# -eq 1 ]; then
    echo $MORE_ARGS_MSG
    exit 0
elif [ $# -eq 0 ]; then
    echo $WRONG_ARGS_MSG
    exit 0
fi

if [ ! -f $1 ]; then
    echo $FILE_NOT_FOUND_MSG
    exit 0;
fi