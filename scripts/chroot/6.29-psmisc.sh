#!/tools/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-psmisc-done ]];then
    pushd $BUILDDIR
    psmisc=$(grep psmisc- /sources/wget-list | grep tar | sed 's/^.*psmisc-/psmisc-/');
    tar -xf /sources/$psmisc;
    cd ${psmisc/.tar*}

    ./configure --prefix=/usr
    make
    make install

    mv -v /usr/bin/fuser /bin
    mv -v /usr/bin/killall /bin

    cd $BUILDDIR
    rm -rf ${psmisc/.tar*}
    popd
    unset psmisc
    touch $BUILDDIR/.chroot-psmisc-done
fi
