#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-patch-done ]];then
    pushd $BUILDDIR
    patch=$(grep patch- /sources/wget-list | grep tar | sed 's/^.*patch-/patch-/');
    tar -xf /sources/$patch;
    cd ${patch/.tar*}

    ./configure --prefix=/usr
    make[[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${patch/.tar*}
    popd
    unset patch
    touch $BUILDDIR/.chroot-patch-done
fi
