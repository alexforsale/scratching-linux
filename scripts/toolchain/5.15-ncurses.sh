#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.ncurses-done ]];then
    pushd $BUILDDIR;
    ncurses=$(grep ncurses /sources/wget-list | sed 's/^.*ncurses/ncurses/');

    tar -xf /sources/$ncurses
    cd ${ncurses/.tar*}

    sed -i s/mawk// configure
    
    ./configure --prefix=/tools \
                --with-shared \
                --without-debug \
                --without-ada \
                --enable-widec \
                --enable-overwrite

    make
    make install

    cd $BUILDDIR
    rm -rf ${ncurses/.tar*}
    popd
    unset ncurses
    touch $BUILDDIR/.ncurses-done
fi
