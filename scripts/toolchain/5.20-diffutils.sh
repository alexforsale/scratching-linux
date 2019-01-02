#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.diffutils-done ]];then
    pushd $BUILDDIR;
    diffutils=$(grep diffutils /sources/wget-list | sed 's/^.*diffutils/diffutils/');

    tar -xf /sources/$diffutils
    cd ${diffutils/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${diffutils/.tar*}
    popd
    unset diffutils
    touch $BUILDDIR/.diffutils-done
fi
