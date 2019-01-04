#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-eudev-done ]];then
    pushd $BUILDDIR
    eudev=$(grep eudev- /sources/wget-list | grep tar | sed 's/^.*eudev-/eudev-/');
    tar -xf /sources/$eudev;
    cd ${eudev/.tar*}

    cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF

    ./configure --prefix=/usr --bindir=/sbin --sbindir=/sbin --libdir=/usr/lib --sysconfdir=/etc \
                --libexecdir=/lib --with-rootprefix= --with-rootlibdir=/lib  --enable-manpages \
                --disable-static --config-cache
    LIBRARY_PATH=/tools/lib make
    mkdir -pv /lib/udev/rules.d
    mkdir -pv /etc/udev/rules.d

    [[ ${TEST} -eq 1 ]] && make LD_LIBRARY_PATH=/tools/lib check
    make LD_LIBRARY_PATH=/tools/lib install
    tar -xvf /sources/udev-lfs-20171102.tar.bz2
    make -f udev-lfs-20171102/Makefile.lfs install
    LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
    
    cd $BUILDDIR
    rm -rf ${eudev/.tar*}
    popd
    unset eudev
    touch $BUILDDIR/.chroot-eudev-done
fi
