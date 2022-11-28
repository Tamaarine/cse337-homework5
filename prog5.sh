#!/bin/bash

# Constants; add more if necessary

MISSING_ARGS_MSG="input file and  dictionary missing"
BAD_ARG_MSG_1="missing no. of characters"
BAD_ARG_MSG_2="Third argument must be an integer greater than 0"
FILE_NOT_FOUND_MSG="not a file"

if [ $# -le 1 ]; then
    echo "$MISSING_ARGS_MSG"
    exit 0
elif [ $# -eq 2 ]; then
    echo $BAD_ARG_MSG_1
    exit 0
fi

# At least three args is provided
pat='^[0-9]+$'

# The input text file doesn't exist
if [ ! -f $1 ]; then
    echo "$1 $FILE_NOT_FOUND_MSG"
    exit 0
elif [ ! -f $2 ]; then
    echo "$2 $FILE_NOT_FOUND_MSG"
    exit 0
elif [[ ! $3 =~ $pat ]] || [ $3 -le 0 ] ; then
    echo $BAD_ARG_MSG_2
    exit 0
fi

words=`cat $1`

mkdir -p awk
cat << 'HEREDOC' > awk/temp4
BEGIN {
    found=0
}
{
    if ($0 == word) {
        found=1
    }
}
END {
    if (found == 0) {
        print word
    }
}
HEREDOC

words_pat='^[a-zA-Z]+$'

position=1
for word in $words; do
    stripped=`echo $word | tr -cd '[:alpha:]'`
    stripped=`echo $stripped | tr '[:upper:]' '[:lower:]'`
    if [ ${#stripped} -eq $3 ] && [[ $stripped =~ $words_pat ]]; then
        ret=`awk -F "" -f awk/temp4 -v word=$stripped $2`
        if [ ! -z $ret ]; then
            echo "$ret; word position=$position"
        fi
    fi
    
    [[ $stripped =~ $words_pat ]] && ((position++))
done

rm -rf awk