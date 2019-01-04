#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.patch-done ]];then
    pushd $BUILDDIR;
    patch=$(grep patch-2 /sources/wget-list | sed 's/^.*patch-2/patch-2/');

    tar -xf /sources/$patch
    cd ${patch/.tar*}

    ./configure --prefix=/tools

    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${patch/.tar*}
    popd
    unset patch
    touch $BUILDDIR/.patch-done
fi
