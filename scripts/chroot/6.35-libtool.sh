#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-libtool-done ]];then
    pushd $BUILDDIR
    libtool=$(grep libtool- /sources/wget-list | grep tar | sed 's/^.*libtool-/libtool-/');
    tar -xf /sources/$libtool;
    cd ${libtool/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${libtool/.tar*}
    popd
    unset libtool
    touch $BUILDDIR/.chroot-libtool-done
fi
