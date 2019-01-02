#!/bin/bash
set -e

. settings.conf

pushd $LFS/sources
[[ ! -f wget-list ]] &&
    wget http://www.linuxfromscratch.org/lfs/view/stable/wget-list
if [[ ! -f .lfs-wget-done ]];then
    wget --input-file=wget-list --continue;
    wget http://www.linuxfromscratch.org/lfs/view/stable/md5sums;
    md5sum -c md5sums;
    touch .lfs-wget-done;
fi
