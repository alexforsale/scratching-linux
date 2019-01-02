#!/bin/bash
set -e
if [[ -z "$(cat /etc/group | grep lfs)" ]];then
    sudo groupadd -g 9000 lfs;
    if ! $(id lfs);then
        sudo useradd -u 9000 -s /bin/bash -g lfs -m -k /dev/null lfs;
    fi
    if ! $(passwd lfs -S);then
        echo -e "create password for user lfs"
        sudo passwd lfs
    fi
fi

if [[ "$(stat -c '%U' $LFS/tools)" != "lfs" ]];then
    sudo chown -v lfs $LFS/tools;
fi

if [[ "$(stat -c '%U' $LFS/sources)" != "lfs" ]];then
    sudo chown -v lfs $LFS/sources;
fi
