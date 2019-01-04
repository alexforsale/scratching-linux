#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-automake-done ]];then
    pushd $BUILDDIR
    automake=$(grep automake- /sources/wget-list | grep tar | sed 's/^.*automake-/automake-/');
    tar -xf /sources/$automake;
    cd ${automake/.tar*}

    ./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
    make
    [[ ${TEST} -eq 1 ]] && make -j8 check
    make install
    
    cd $BUILDDIR
    rm -rf ${automake/.tar*}
    popd
    unset automake
    touch $BUILDDIR/.chroot-automake-done
fi
