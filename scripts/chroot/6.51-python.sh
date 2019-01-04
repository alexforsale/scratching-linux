#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-python-done ]];then
    pushd $BUILDDIR
    python=$(grep Python- /sources/wget-list | grep tar | sed 's/^.*Python-/Python-/');
    tar -xf /sources/$python;
    cd ${python/.tar*}

    ./configure --prefix=/usr --enable-shared --with-system-expat --with-system-ffi --with-ensurepip=yes
    make

    make install
    chmod -v 755 /usr/lib/libpython3.7m.so
    chmod -v 755 /usr/lib/libpython3.so

    install -v -dm755 /usr/share/doc/python-3.7.0/html 

    tar --strip-components=1 --no-same-owner --no-same-permissions -C /usr/share/doc/python-3.7.0/html \
        -xvf /sources/python-3.7.0-docs-html.tar.bz2

    cd $BUILDDIR
    rm -rf ${python/.tar*}
    popd
    unset python
    touch $BUILDDIR/.chroot-python-done
fi
