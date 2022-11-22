#!/bin/bash

#Constants; add more if necessary
MISSING_ARGS_MSG="Missing data file"

if [ $# -lt 1 ] || [ ! -f $1 ]; then
    echo $MISSING_ARGS_MSG
    exit 0
fi

in_weights=""
let "end_index=$# - 1"
args=($@)
for i in `seq 1 $end_index`; do
    in_weights="$in_weights ${args[i]}"
done

mkdir -p awk
cat << 'HEREDOC' > awk/temp2
BEGIN {
    n=split(in_weights, weights, " ") # 1 based indexing
    lines_processed=0
    weight_sum=0
}
{
    if (NR == 1) {
        diff_needed=NF - n - 1
        for(i=0;i<diff_needed;i++) {
            # Need to add the 1 weights
            weights[n+1]=1
            n++
        }
        # Calculate the weight_sum after adding the 1s needed
        for(i=1;i<NF;i++) {
            weight_sum+=weights[i]
        }
    }
    else {
        for(i=2;i<=NF;i++) {
            sums[lines_processed]+=($i * weights[i-1])
        }
        lines_processed++
    }
}
END {
    avg=0
    for(i=0;i<lines_processed;i++) {
        sums[i]/=weight_sum
        avg+=sums[i]
    }
    avg/=lines_processed
    print int(avg)
}

HEREDOC

awk -f awk/temp2 -v in_weights="$in_weights" $1
rm -rf awk