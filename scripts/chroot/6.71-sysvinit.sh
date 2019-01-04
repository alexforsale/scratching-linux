#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-sysvinit-done ]];then
    pushd $BUILDDIR
    sysvinit=$(grep sysvinit- /sources/wget-list | grep tar | sed 's/^.*sysvinit-/sysvinit-/');
    tar -xf /sources/$sysvinit;
    cd ${sysvinit/.tar*}

    patch -Np1 -i /sources/sysvinit-2.90-consolidated-1.patch
    make -C src
    make -C src install
    
    cd $BUILDDIR
    rm -rf ${sysvinit/.tar*}
    popd
    unset sysvinit
    touch $BUILDDIR/.chroot-sysvinit-done
fi
