#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.texinfo-done ]];then
    pushd $BUILDDIR;
    texinfo=$(grep texinfo /sources/wget-list | sed 's/^.*texinfo/texinfo/');

    tar -xf /sources/$texinfo
    cd ${texinfo/.tar*}

    ./configure --prefix=/tools
    make
    [[ -n "${TEST}" ]] && make check
    make install
    
    cd $BUILDDIR
    rm -rf ${texinfo/.tar*}
    popd
    unset texinfo
    touch $BUILDDIR/.texinfo-done
fi
