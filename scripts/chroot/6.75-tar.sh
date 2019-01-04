#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-tar-done ]];then
    pushd $BUILDDIR
    tar=$(grep tar- /sources/wget-list | grep tar | sed 's/^.*tar-/tar-/');
    tar -xf /sources/$tar;
    cd ${tar/.tar*}
    
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --bindir=/bin
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    make -C doc install-html docdir=/usr/share/doc/tar-1.30

    cd $BUILDDIR
    rm -rf ${tar/.tar*}
    popd
    unset tar
    touch $BUILDDIR/.chroot-tar-done
fi
