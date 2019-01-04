#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-xmlparser-done ]];then
    pushd $BUILDDIR
    xmlparser=$(grep XML-Parser /sources/wget-list | grep tar | sed 's/^.*XML-Parser-/XML-Parser-/');
    tar -xf /sources/$xmlparser;
    cd ${xmlparser/.tar*}

    perl Makefile.PL
    make
    [[ ${TEST} -eq 1 ]] && make test
    make install
    
    cd $BUILDDIR
    rm -rf ${xmlparser/.tar*}
    popd
    unset xmlparser
    touch $BUILDDIR/.chroot-xmlparser-done
fi
