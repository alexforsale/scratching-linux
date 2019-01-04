#!/bin/bash

for d in dev proc sys run;do
    if [[ ! -d $LFS/$d ]];then
        sudo mkdir -pv $LFS/$d
    fi
done

[[ ! -c $LFS/dev/console ]] && sudo mknod -m 600 $LFS/dev/console c 5 1
[[ ! -c $LFS/dev/null ]] && sudo mknod -m 666 $LFS/dev/null c 1 3

[[ -z "$(mount | grep $LFS/dev)" ]] && sudo mount -v --bind /dev $LFS/dev

[[ -z "$(mount | grep $LFS/dev/pts)" ]] &&
    sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
[[ -z "$(mount | grep $LFS/proc)" ]] && sudo mount -vt proc proc $LFS/proc
[[ -z "$(mount | grep $LFS/sys)" ]] && sudo mount -vt sysfs sysfs $LFS/sys
[[ -z "$(mount | grep $LFS/run)" ]] && sudo mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
