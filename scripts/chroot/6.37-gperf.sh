#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-gperf-done ]];then
    pushd $BUILDDIR
    gperf=$(grep gperf- /sources/wget-list | grep tar | sed 's/^.*gperf-/gperf-/');
    tar -xf /sources/$gperf;
    cd ${gperf/.tar*}

    ./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
    make
    [[ ${TEST} -eq 1 ]] && make -j1 check
    make install
    
    cd $BUILDDIR
    rm -rf ${gperf/.tar*}
    popd
    unset gperf
    touch $BUILDDIR/.chroot-gperf-done
fi
