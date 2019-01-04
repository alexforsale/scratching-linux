#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-utillinux-done ]];then
    pushd $BUILDDIR
    utillinux=$(grep util-linux- /sources/wget-list | grep tar | sed 's/^.*util-linux-/util-linux-/');
    tar -xf /sources/$utillinux;
    cd ${utillinux/.tar*}

    mkdir -pv /var/lib/hwclock
    rm -vf /usr/include/{blkid,libmount,uuid}
    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
                --docdir=/usr/share/doc/util-linux-2.32.1 \
                --disable-chfn-chsh \
                --disable-login \
                --disable-nologin \
                --disable-su \
                --disable-setpriv \
                --disable-runuser \
                --disable-pylibmount \
                --disable-static \
                --without-python \
                --without-systemd \
                --without-systemdsystemunitdir
    make
    if [[ ${TEST} -eq 1 ]];then
        chown -Rv nobody .
        su nobody -s /bin/bash -c "PATH=$PATH make -k check"
    fi
    make install
    
    cd $BUILDDIR
    rm -rf ${utillinux/.tar*}
    popd
    unset utillinux
    touch $BUILDDIR/.chroot-utillinux-done
fi
