#!/bin/sh

do_defrag_path() {
    path=$1
    set -- sudo btrfs fi defrag "${path}"
    echo "RUN: $@"
    time "$@"
}

do_defrag_filesystem() {
    root=$1

    echo "found btrfs mount on: ${root}"

    sudo btrfs su li "${root}" | while read subvol_line
    do
        # parse something like that:
        # #1 #2  #3  #4     #5  #6   #7 #8   #9
        # ID 498 gen 703177 top level 5 path subvolumes/var_tmp
        # ID 517 gen 658092 top level 5 path subvolumes/home_prefix
        set -- ${subvol_line}
        subvol_path=${root}$9
        do_defrag_path "${subvol_path}"
    done

    do_defrag_path "${root}"
}

while read mounts_line
do
    set -- ${mounts_line}

    # parse something like that:
    # #1         #2         #3    #4
    # /dev/sda5  /          btrfs rw,noatime,nodiratime,thread_pool=1,compress=lzo,space_cache 0 0
    # none       /proc      proc  rw,relatime 0 0
    # tmpfs      /run       tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
    # /dev/loop0 /gentoo-4k btrfs rw,noatime,nodiratime,nodatasum,nodatacow,thread_pool=1,space_cache 0 0

    [ x$3 = xbtrfs ] && do_defrag_filesystem $2

done </etc/mtab
