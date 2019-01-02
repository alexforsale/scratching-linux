#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.bzip2-done ]];then
    pushd $BUILDDIR;
    bzip2=$(grep bzip2 /sources/wget-list | grep tar | sed 's/^.*bzip2/bzip2/');

    tar -xf /sources/$bzip2
    cd ${bzip2/.tar*}

    make
    make PREFIX=/tools install

    cd $BUILDDIR
    rm -rf ${bzip2/.tar*}
    popd
    unset bzip2
    touch $BUILDDIR/.bzip2-done
fi
