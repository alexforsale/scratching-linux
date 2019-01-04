#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-diffutils-done ]];then
    pushd $BUILDDIR
    diffutils=$(grep diffutils- /sources/wget-list | grep tar | sed 's/^.*diffutils-/diffutils-/');
    tar -xf /sources/$diffutils;
    cd ${diffutils/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${diffutils/.tar*}
    popd
    unset diffutils
    touch $BUILDDIR/.chroot-diffutils-done
fi
