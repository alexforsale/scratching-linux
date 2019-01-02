#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.coreutils-done ]];then
    pushd $BUILDDIR;
    coreutils=$(grep coreutils /sources/wget-list | grep tar | sed 's/^.*coreutils/coreutils/');

    tar -xf /sources/$coreutils
    cd ${coreutils/.tar*}

    ./configure --prefix=/tools --enable-install-program=hostname
    make
    [[ -n "${TEST}" ]] && make RUN_EXPENSIVE_TESTS=yes check
    make install

    cd $BUILDDIR
    rm -rf ${coreutils/.tar*}
    popd
    unset coreutils
    touch $BUILDDIR/.coreutils-done
fi
