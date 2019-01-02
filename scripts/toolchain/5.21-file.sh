#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.file-done ]];then
    pushd $BUILDDIR;
    file=$(grep file- /sources/wget-list | sed 's/^.*file-/file-/');

    tar -xf /sources/$file
    cd ${file/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${file/.tar*}
    popd
    unset file
    touch $BUILDDIR/.file-done
fi
