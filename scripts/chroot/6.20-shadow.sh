#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-shadow-done ]];then
    pushd $BUILDDIR
    shadow=$(grep shadow- /sources/wget-list | grep tar | sed 's/^.*shadow-/shadow-/');
    tar -xf /sources/$shadow;
    cd ${shadow/.tar*}

    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
        -e 's@/var/spool/mail@/var/mail@' etc/login.defs

    sed -i 's/1000/999/' etc/useradd

    ./configure --sysconfdir=/etc --with-group-name-max-length=32
    make
    make install

    mv -v /usr/bin/passwd /bin

    pwconv
    grpconv

    echo -e "input password for root user"
    passwd root
    
    cd $BUILDDIR
    rm -rf ${shadow/.tar*}
    popd
    unset shadow
    touch $BUILDDIR/.chroot-shadow-done
fi
