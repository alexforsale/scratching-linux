#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-autoconf-done ]];then
    pushd $BUILDDIR
    autoconf=$(grep autoconf- /sources/wget-list | grep tar | sed 's/^.*autoconf-/autoconf-/');
    tar -xf /sources/$autoconf;
    cd ${autoconf/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${autoconf/.tar*}
    popd
    unset autoconf
    touch $BUILDDIR/.chroot-autoconf-done
fi
