#! /bin/bash

# Contants; add more if necessary
MISSING_ARGS_MSG="src and dest missing"
MORE_ARGS_MSG="Exactly 2 arguments required"
MISSING_SRC="src not found"

# Checking args
if [ $# -gt 2 ]; then
    echo $MORE_ARGS_MSG
    exit 0
elif [ $# -eq 0 ]; then
    echo $MISSING_ARGS_MSG
    exit 0
elif [ $# -ne 2 ]; then
    echo $MISSING_SRC
    exit 0
fi

# Ensure src is valid
if [ ! -d $1 ]; then
    echo $MISSING_SRC
    exit 0
fi

# Delete & create again if destination exists
if [ -d $2 ]; then
    # echo "rm -rf $2"
    rm -rf $2
    mkdir -p $2
else
    mkdir -p $2
fi

subdirs=`find $1 -type d`
for path in ${subdirs[@]}; do
    c_files=`find $path -maxdepth 1 -type f -name "*.c"`
    length=`find $path -maxdepth 1 -type f -name "*.c" | wc -l`
    echo $c_files
    if [ $length -gt 3 ]; then
        # Ask user before moving
        echo -e "$c_files"
        echo -n "Are you sure you want to move all these files? "
        read input
        
        if [ -z $input ]; then
            move="no"
        elif [ ${input:0:1} = "y" ] || [ ${input:0:1} = "Y" ]; then
            move="yes"
        else
            move="no"
        fi
    else
        move="yes"
    fi
    
    if [ $move = "yes" ]; then
        for file in ${c_files[@]}; do
            new_path=`realpath -m "$2/$file"`
            echo $new_path
            
            # Create the new sub-directories if it doesn't exists
            mkdir -p `dirname $new_path`
            
            # Move the files!
            echo "$file to $new_path"
            mv $file $new_path
        done
    fi
done
