#!/bin/sh

do_defrag() {
    path=$1
    set -- sudo btrfs fi defrag $path
    echo "RUN: $@"
    time "$@"
}

root=/

sudo btrfs su li $root | while read args
do
    # parse something like that:
    # #1 #2  #3  #4    #5 #6   #7
    # ID 673 top level 5  path subvolumes/var_tmp
    set -- $args
    subvol_path=$root$7
    do_defrag "$subvol_path"
done

do_defrag "$root"
