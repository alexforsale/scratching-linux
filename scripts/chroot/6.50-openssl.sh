#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-openssl-done ]];then
    pushd $BUILDDIR
    openssl=$(grep openssl- /sources/wget-list | grep tar | sed 's/^.*openssl-/openssl-/');
    tar -xf /sources/$openssl;
    cd ${openssl/.tar*}

    ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
    make
    [[ ${TEST} -eq 1 ]] && make test

    sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
    make MANSUFFIX=ssl install

    mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.0i
    cp -vfr doc/* /usr/share/doc/openssl-1.1.0i

    cd $BUILDDIR
    rm -rf ${openssl/.tar*}
    popd
    unset openssl
    touch $BUILDDIR/.chroot-openssl-done
fi
