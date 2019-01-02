#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.grep-done ]];then
    pushd $BUILDDIR;
    grep=$(grep "grep" /sources/wget-list | sed 's/^.*grep/grep/');

    tar -xf /sources/$grep
    cd ${grep/.tar*}

    ./configure --prefix=/tools

    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${grep/.tar*}
    popd
    unset grep
    touch $BUILDDIR/.grep-done
fi
