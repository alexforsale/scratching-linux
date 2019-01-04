#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-zlib-done ]];then
    pushd $BUILDDIR
    zlib=$(grep zlib /sources/wget-list | grep tar | sed 's/^.*zlib/zlib/');
    tar -xf /sources/$zlib;
    cd ${zlib/.tar*}

    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    mv -v /usr/lib/libz.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

    cd $BUILDDIR
    rm -rf ${zlib/.tar*}
    popd
    unset zlib
    touch $BUILDDIR/.chroot-zlib-done
fi

