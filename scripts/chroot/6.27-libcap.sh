#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-libcap-done ]];then
    pushd $BUILDDIR
    libcap=$(grep libcap- /sources/wget-list | grep tar | sed 's/^.*libcap-/libcap-/');
    tar -xf /sources/$libcap;
    cd ${libcap/.tar*}

    sed -i '/install.*STALIBNAME/d' libcap/Makefile
    make
    make RAISE_SETFCAP=no lib=lib prefix=/usr install
    chmod -v 755 /usr/lib/libcap.so

    mv -v /usr/lib/libcap.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
    
    cd $BUILDDIR
    rm -rf ${libcap/.tar*}
    popd
    unset libcap
    touch $BUILDDIR/.chroot-libcap-done
fi
