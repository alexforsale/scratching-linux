#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.util-linux-done ]];then
    pushd $BUILDDIR;
    util_linux=$(grep util-linux /sources/wget-list | sed 's/^.*util-linux/util-linux/');

    tar -xf /sources/$util_linux
    cd ${util_linux/.tar*}

    ./configure --prefix=/tools \
                --without-python \
                --disable-makeinstall-chown \
                --without-systemdsystemunitdir \
                --without-ncurses \
                PKG_CONFIG=""

    make
    make install
    
    cd $BUILDDIR
    rm -rf ${util_linux/.tar*}
    popd
    unset util_linux
    touch $BUILDDIR/.util-linux-done
fi
