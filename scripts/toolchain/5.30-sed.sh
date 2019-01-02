#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.sed-done ]];then
    pushd $BUILDDIR;
    sed=$(grep sed /sources/wget-list | sed 's/^.*sed/sed/');

    tar -xf /sources/$sed
    cd ${sed/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${sed/.tar*}
    popd
    unset sed
    touch $BUILDDIR/.sed-done
fi
