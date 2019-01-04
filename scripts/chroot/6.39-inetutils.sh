#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-inetutils-done ]];then
    pushd $BUILDDIR
    inetutils=$(grep inetutils- /sources/wget-list | grep tar | sed 's/^.*inetutils-/inetutils-/');
    tar -xf /sources/$inetutils;
    cd ${inetutils/.tar*}

    ./configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois \
                --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers
    make
    [[ ${TEST} -eq 1 ]] && make check
    make install

    mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
    mv -v /usr/bin/ifconfig /sbin

    cd $BUILDDIR
    rm -rf ${inetutils/.tar*}
    popd
    unset inetutils
    touch $BUILDDIR/.chroot-inetutils-done
fi
