#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.tcl-done ]];then
    pushd $BUILDDIR;
    tcl=$(grep tcl /sources/wget-list | sed 's/^.*tcl/tcl/');

    tar -xf /sources/$tcl
    cd ${tcl/-src*}

    cd unix
    ./configure --prefix=/tools

    make

    [[ -n "${TEST}" ]] && TZ=UTC make test

    make install

    chmod -v u+w /tools/lib/libtcl8.6.so
    make install-private-headers
    ln -sv tclsh8.6 /tools/bin/tclsh

    cd $BUILDDIR
    rm -rf ${tcl/-src*}
    popd
    unset tcl
    touch $BUILDDIR/.tcl-done
fi
