#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.bison-done ]];then
    pushd $BUILDDIR;
    bison=$(grep bison /sources/wget-list | sed 's/^.*bison/bison/');

    tar -xf /sources/$bison
    cd ${bison/.tar*}

    ./configure --prefix=/tools

    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    cd $BUILDDIR
    rm -rf ${bison/.tar*}
    popd
    unset bison
    touch $BUILDDIR/.bison-done
fi
