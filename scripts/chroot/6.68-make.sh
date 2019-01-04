#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-make-done ]];then
    pushd $BUILDDIR
    make=$(grep make-4 /sources/wget-list | grep tar | sed 's/^.*make-4/make-4/');
    tar -xf /sources/$make;
    cd ${make/.tar*}
    
    sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make PERL5LIB=$PWD/tests/ check
    make install
    
    cd $BUILDDIR
    rm -rf ${make/.tar*}
    popd
    unset make
    touch $BUILDDIR/.chroot-make-done
fi
