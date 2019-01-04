#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-coreutils-done ]];then
    pushd $BUILDDIR
    coreutils=$(grep coreutils- /sources/wget-list | grep tar | sed 's/^.*coreutils-/coreutils-/');
    tar -xf /sources/$coreutils;
    cd ${coreutils/.tar*}

    patch -Np1 -i /sources/coreutils-8.30-i18n-1.patch
    sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
    autoreconf -fiv
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-no-install-program=kill,uptime
    FORCE_UNSAFE_CONFIGURE=1 make
    if [[ ${TEST} -eq 1 ]];then
        make NON_ROOT_USERNAME=nobody check-root
        echo "dummy:x:1000:nobody" >> /etc/group
        chown -Rv nobody .
        su nobody -s /bin/bash \
           -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
        sed -i '/dummy/d' /etc/group
    fi
    make install

    /tools/bin/mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
    /tools/bin/mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
    /tools/bin/mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
    /tools/bin/mv -v /usr/bin/chroot /usr/sbin
    /tools/bin/mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
    /tools/bin/mv -v /usr/bin/{head,sleep,nice} /bin

    cd $BUILDDIR
    rm -rf ${coreutils/.tar*}
    popd
    unset coreutils
    touch $BUILDDIR/.chroot-coreutils-done
fi
