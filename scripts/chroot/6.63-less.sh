#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-less-done ]];then
    pushd $BUILDDIR
    less=$(grep less- /sources/wget-list | grep tar | sed 's/^.*less-/less-/');
    tar -xf /sources/$less;
    cd ${less/.tar*}

    ./configure --prefix=/usr --sysconfdir=/etc
    make
    make install
    
    cd $BUILDDIR
    rm -rf ${less/.tar*}
    popd
    unset less
    touch $BUILDDIR/.chroot-less-done
fi
