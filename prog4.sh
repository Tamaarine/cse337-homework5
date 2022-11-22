#!/bin/bash

# Constants; add more if necessary

MISSING_ARGS_MSG="Score directory missing"
ERR_MSG="not a directory"

if [ $# -ne 1 ]; then
    echo $MISSING_ARGS_MSG
    exit 0
elif [ ! -d $1 ]; then
    echo "$1 $ERR_MSG"
    exit 0
fi

mkdir -p awk
cat << 'HEREDOC' > awk/temp3
{
    if (NR == 1) {
        # Skip the first row
    }
    else if (NR == 2) {
        avg=0
        for(i=2;i<=NF;i++) {
            avg+=$i
        }
        avg/=NF-1
        avg*=10
        if (avg >= 93)
            print $1 " : " "A"
        else if (avg >= 80)
            print $1 " : " "B"
        else if (avg >= 65)
            print $1 " : " "C"
        else
            print $1 " : " "D"
    }
}

HEREDOC

scores=`find ./scores -type f | grep -E "prob4-score[0-9]+.txt"`

for entry in $scores; do
    awk -F , -f awk/temp3 $entry
done

rm -rf awk