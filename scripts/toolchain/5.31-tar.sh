#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.tar-done ]];then
    pushd $BUILDDIR;
    tar=$(grep tar- /sources/wget-list | sed 's/^.*tar-/tar-/');

    tar -xf /sources/$tar
    cd ${tar/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${tar/.tar*}
    popd
    unset tar
    touch $BUILDDIR/.tar-done
fi
