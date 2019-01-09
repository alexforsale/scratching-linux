#!/bin/bash
set -e

chroot_lfs_pacman /sources/scripts/chroot/6.35-libtool.sh
chroot_lfs /sources/scripts/chroot/6.35-libtool.sh

chroot_lfs_pacman /sources/scripts/chroot/6.36-gdbm.sh
chroot_lfs /sources/scripts/chroot/6.36-gdbm.sh

chroot_lfs_pacman /sources/scripts/chroot/6.37-gperf.sh
chroot_lfs /sources/scripts/chroot/6.37-gperf.sh

chroot_lfs_pacman /sources/scripts/chroot/6.38-expat.sh
chroot_lfs /sources/scripts/chroot/6.38-expat.sh

chroot_lfs_pacman /sources/scripts/chroot/6.39-inetutils.sh
chroot_lfs /sources/scripts/chroot/6.39-inetutils.sh

chroot_lfs /sources/scripts/chroot/6.40-perl.sh prepare
chroot_lfs_pacman /sources/scripts/chroot/6.40-perl.sh
chroot_lfs /sources/scripts/chroot/6.40-perl.sh

chroot_lfs_pacman /sources/scripts/chroot/6.41-xmlparser.sh
chroot_lfs /sources/scripts/chroot/6.41-xmlparser.sh

chroot_lfs_pacman /sources/scripts/chroot/6.42-intltool.sh
chroot_lfs /sources/scripts/chroot/6.42-intltool.sh

chroot_lfs_pacman /sources/scripts/chroot/6.43-autoconf.sh
chroot_lfs /sources/scripts/chroot/6.43-autoconf.sh

chroot_lfs_pacman /sources/scripts/chroot/6.44-automake.sh
chroot_lfs /sources/scripts/chroot/6.44-automake.sh

chroot_lfs_pacman /sources/scripts/chroot/6.45-xz.sh
chroot_lfs /sources/scripts/chroot/6.45-xz.sh

chroot_lfs_pacman /sources/scripts/chroot/6.46-kmod.sh
chroot_lfs /sources/scripts/chroot/6.46-kmod.sh

chroot_lfs_pacman /sources/scripts/chroot/6.47-gettext.sh
chroot_lfs /sources/scripts/chroot/6.47-gettext.sh

chroot_lfs_pacman /sources/scripts/chroot/6.48-libelf.sh
chroot_lfs /sources/scripts/chroot/6.48-libelf.sh

chroot_lfs_pacman /sources/scripts/chroot/6.49-libffi.sh
chroot_lfs /sources/scripts/chroot/6.49-libffi.sh

chroot_lfs_pacman /sources/scripts/chroot/6.50a-fakeroot.sh
chroot_lfs /sources/scripts/chroot/6.50a-fakeroot.sh

chroot_lfs_pacman /sources/scripts/chroot/6.50-openssl.sh
chroot_lfs /sources/scripts/chroot/6.50-openssl.sh

chroot_lfs_pacman /sources/scripts/chroot/6.51a-tcl.sh
chroot_lfs /sources/scripts/chroot/6.51a-tcl.sh

pushd /sources
[[ ! -f /sources/lz4-1.8.3.tar.gz ]] &&
    wget https://github.com/lz4/lz4/archive/v1.8.3.tar.gz \
         -O lz4-1.8.3.tar.gz
popd

chroot_lfs_pacman /sources/scripts/chroot/6.51aaa-lz4.sh
chroot_lfs /sources/scripts/chroot/6.51aaa-lz4.sh

pushd /sources
[[ ! -f /sources/libarchive-3.3.3.tar.gz ]] &&
    wget https://github.com/libarchive/libarchive/archive/v3.3.3.tar.gz \
         -O libarchive-3.3.3.tar.gz
popd

chroot_lfs_pacman /sources/scripts/chroot/6.51aa-libarchive.sh
chroot_lfs /sources/scripts/chroot/6.51aa-libarchive.sh

pushd /sources
[[ ! -f /sources/sqlite-src-3260000.zip ]] &&
    wget https://www.sqlite.org/2018/sqlite-src-3260000.zip
[[ ! -f /sources/sqlite-doc-3260000.zip ]] &&
    wget https://www.sqlite.org/2018/sqlite-doc-3260000.zip
popd

chroot_lfs_pacman /sources/scripts/chroot/6.51b-sqlite.sh
chroot_lfs /sources/scripts/chroot/6.51b-sqlite.sh

chroot_lfs_pacman /sources/scripts/chroot/6.51c-mpdecimal.sh
chroot_lfs /sources/scripts/chroot/6.51c-mpdecimal.sh

chroot_lfs_pacman /sources/scripts/chroot/6.51-python.sh
chroot_lfs /sources/scripts/chroot/6.51-python.sh

chroot_lfs_pacman /sources/scripts/chroot/6.52-ninja.sh
chroot_lfs /sources/scripts/chroot/6.52-ninja.sh

chroot_lfs_pacman /sources/scripts/chroot/6.53-meson.sh
chroot_lfs /sources/scripts/chroot/6.53-meson.sh

chroot_lfs_pacman /sources/scripts/chroot/6.54-procps-ng.sh
chroot_lfs /sources/scripts/chroot/6.54-procps-ng.sh

chroot_lfs_pacman /sources/scripts/chroot/6.55-e2fsprogs.sh
chroot_lfs /sources/scripts/chroot/6.55-e2fsprogs.sh

chroot_lfs_pacman /sources/scripts/chroot/6.56-coreutils.sh
chroot_lfs /sources/scripts/chroot/6.56-coreutils.sh

chroot_lfs_pacman /sources/scripts/chroot/6.57-check.sh
chroot_lfs /sources/scripts/chroot/6.57-check.sh

chroot_lfs_pacman /sources/scripts/chroot/6.58-diffutils.sh
chroot_lfs /sources/scripts/chroot/6.58-diffutils.sh

chroot_lfs_pacman /sources/scripts/chroot/6.59-gawk.sh
chroot_lfs /sources/scripts/chroot/6.59-gawk.sh

chroot_lfs_pacman /sources/scripts/chroot/6.60-findutils.sh
chroot_lfs /sources/scripts/chroot/6.60-findutils.sh

chroot_lfs_pacman /sources/scripts/chroot/6.61-groff.sh
chroot_lfs /sources/scripts/chroot/6.61-groff.sh

chroot_lfs_pacman /sources/scripts/chroot/6.62-grub.sh
chroot_lfs /sources/scripts/chroot/6.62-grub.sh

chroot_lfs_pacman /sources/scripts/chroot/6.63-less.sh
chroot_lfs /sources/scripts/chroot/6.63-less.sh

chroot_lfs_pacman /sources/scripts/chroot/6.64-gzip.sh
chroot_lfs /sources/scripts/chroot/6.64-gzip.sh

chroot_lfs_pacman /sources/scripts/chroot/6.65-iproute2.sh
chroot_lfs /sources/scripts/chroot/6.65-iproute2.sh

chroot_lfs_pacman /sources/scripts/chroot/6.66-kbd.sh
chroot_lfs /sources/scripts/chroot/6.66-kbd.sh

chroot_lfs_pacman /sources/scripts/chroot/6.67-libpipeline.sh
chroot_lfs /sources/scripts/chroot/6.67-libpipeline.sh

chroot_lfs_pacman /sources/scripts/chroot/6.68-make.sh
chroot_lfs /sources/scripts/chroot/6.68-make.sh

chroot_lfs_pacman /sources/scripts/chroot/6.69-patch.sh
chroot_lfs /sources/scripts/chroot/6.69-patch.sh

chroot_lfs_pacman /sources/scripts/chroot/6.70-sysklogd.sh
chroot_lfs /sources/scripts/chroot/6.70-sysklogd.sh

chroot_lfs_pacman /sources/scripts/chroot/6.71-sysvinit.sh
chroot_lfs /sources/scripts/chroot/6.71-sysvinit.sh

chroot_lfs_pacman /sources/scripts/chroot/6.72-eudev.sh
chroot_lfs /sources/scripts/chroot/6.72-eudev.sh

chroot_lfs_pacman /sources/scripts/chroot/6.73-util-linux.sh
chroot_lfs /sources/scripts/chroot/6.73-util-linux.sh

chroot_lfs_pacman /sources/scripts/chroot/6.74-man-db.sh
chroot_lfs /sources/scripts/chroot/6.74-man-db.sh

chroot_lfs_pacman /sources/scripts/chroot/6.75-tar.sh
chroot_lfs /sources/scripts/chroot/6.75-tar.sh

chroot_lfs_pacman /sources/scripts/chroot/6.76-texinfo.sh
chroot_lfs /sources/scripts/chroot/6.76-texinfo.sh

chroot_lfs_pacman /sources/scripts/chroot/6.77-vim.sh
chroot_lfs /sources/scripts/chroot/6.77-vim.sh
