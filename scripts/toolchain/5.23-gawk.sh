#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.gawk-done ]];then
    pushd $BUILDDIR;
    gawk=$(grep gawk /sources/wget-list | sed 's/^.*gawk/gawk/');

    tar -xf /sources/$gawk
    cd ${gawk/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${gawk/.tar*}
    popd
    unset gawk
    touch $BUILDDIR/.gawk-done
fi
