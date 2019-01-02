#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.xz-done ]];then
    pushd $BUILDDIR;
    xz=$(grep xz- /sources/wget-list | sed 's/^.*xz-/xz-/');

    tar -xf /sources/$xz
    cd ${xz/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${xz/.tar*}
    popd
    unset xz
    touch $BUILDDIR/.xz-done
fi
