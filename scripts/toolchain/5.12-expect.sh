#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.expect-done ]];then
    pushd $BUILDDIR;
    expect=$(grep expect /sources/wget-list | sed 's/^.*expect/expect/');

    tar -xf /sources/$expect
    cd ${expect/.tar*}

    cp -v configure{,.orig}
    sed 's:/usr/local/bin:/bin:' configure.orig > configure

    ./configure --prefix=/tools \
                --with-tcl=/tools/lib \
                --with-tclinclude=/tools/include

    make
    [[ ${TEST} -eq 1 ]] && make test
    make SCRIPTS="" install

    cd $BUILDDIR
    rm -rf ${expect/.tar*}
    popd
    unset expect
    touch $BUILDDIR/.expect-done
fi
