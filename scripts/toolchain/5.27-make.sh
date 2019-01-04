#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.make-done ]];then
    pushd $BUILDDIR;
    make=$(grep make-4 /sources/wget-list | sed 's/^.*make-4/make-4/');

    tar -xf /sources/$make
    cd ${make/.tar*}

    sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c

    ./configure --prefix=/tools --without-guile

    make
    [[ ${TEST} -eq 1 ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${make/.tar*}
    popd
    unset make
    touch $BUILDDIR/.make-done
fi
