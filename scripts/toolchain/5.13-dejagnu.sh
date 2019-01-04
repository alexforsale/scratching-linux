#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.dejagnu-done ]];then
    pushd $BUILDDIR;
    dejagnu=$(grep dejagnu /sources/wget-list | sed 's/^.*dejagnu/dejagnu/');

    tar -xf /sources/$dejagnu
    cd ${dejagnu/.tar*}

    ./configure --prefix=/tools
    make
    make install
    [[ ${TEST} -eq 1 ]] && make check

    cd $BUILDDIR
    rm -rf ${dejagnu/.tar*}
    popd
    unset dejagnu
    touch $BUILDDIR/.dejagnu-done
fi
