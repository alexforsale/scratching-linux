#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.bash-done ]];then
    pushd $BUILDDIR;
    bash=$(grep bash /sources/wget-list | sed 's/^.*bash/bash/');

    tar -xf /sources/$bash
    cd ${bash/.tar*}

    ./configure --prefix=/tools --without-bash-malloc

    make
    [[ ${TEST} -eq 1 ]] && make tests
    make install

    ln -sv bash /tools/bin/sh

    cd $BUILDDIR
    rm -rf ${bash/.tar*}
    popd
    unset bash
    touch $BUILDDIR/.bash-done
fi
