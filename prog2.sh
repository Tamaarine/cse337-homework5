#!/bin/bash

# Constants; add more if necessary
WRONG_ARGS_MSG="data file or output file missing"
FILE_NOT_FOUND_MSG="file not found"
MORE_ARGS_MSG="Exactly 2 arguments required"

# Checking args
if [ $# -ne 2 ]; then
    echo $WRONG_ARGS_MSG
    exit 0
fi

if [ ! -f $1 ]; then
    echo "`basename $1` $FILE_NOT_FOUND_MSG"
    exit 0;
fi

mkdir -p awk
cat << 'HEREDOC' > awk/temp1
BEGIN {
    largest_nf=0
}
{
    if (NF > largest_nf)
    {
        largest_nf=NF
    }
    for(i=1;i<=NF;i++) {
        sum[i]+=$i
    }
}
END {
    for(i=1;i<=largest_nf;i++) {
        print "Col " i " : " sum[i]
    }
}
HEREDOC

awk -F ",|:|;" -f awk/temp1 $1 > $2
rm -rf awk