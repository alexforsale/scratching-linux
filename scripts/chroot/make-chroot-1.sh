#!/tools/bin/bash
set -e

sudo chown 8000:8000 $BUILDDIR -R

chroot_lfs /sources/scripts/chroot/6.6-Creating-essential-files-and-symlinks.sh
chroot_lfs_pacman /sources/scripts/chroot/6.7-linux-api-headers.sh
chroot_lfs /sources/scripts/chroot/6.7-linux-api-headers.sh

chroot_lfs_pacman /sources/scripts/chroot/6.8-man-pages.sh
chroot_lfs /sources/scripts/chroot/6.8-man-pages.sh

pushd /sources
[[ ! -f tzcode2018e.tar.gz ]] &&
    wget https://www.iana.org/time-zones/repository/releases/tzcode2018e.tar.gz
popd
chroot_lfs_pacman /sources/scripts/chroot/6.9a-tzdata.sh
chroot_lfs /sources/scripts/chroot/6.9a-tzdata.sh

chroot_lfs /sources/scripts/chroot/6.9-glibc.sh prepare
chroot_lfs_pacman /sources/scripts/chroot/6.9-glibc.sh
chroot_lfs /sources/scripts/chroot/6.9-glibc.sh
chroot_lfs /sources/scripts/chroot/6.9a-tzdata.sh post-install

chroot_lfs /sources/scripts/chroot/6.10-Adjusting-the-Toolchain.sh

chroot_lfs_pacman /sources/scripts/chroot/6.11-zlib.sh
chroot_lfs /sources/scripts/chroot/6.11-zlib.sh

chroot_lfs_pacman /sources/scripts/chroot/6.12-file.sh
chroot_lfs /sources/scripts/chroot/6.12-file.sh

chroot_lfs_pacman /sources/scripts/chroot/6.13-readline.sh
chroot_lfs /sources/scripts/chroot/6.13-readline.sh

chroot_lfs_pacman /sources/scripts/chroot/6.14-m4.sh
chroot_lfs /sources/scripts/chroot/6.14-m4.sh

chroot_lfs /sources/scripts/chroot/6.15-bc.sh prepare
chroot_lfs_pacman /sources/scripts/chroot/6.15-bc.sh
chroot_lfs /sources/scripts/chroot/6.15-bc.sh

chroot_lfs /sources/scripts/chroot/6.16-binutils.sh prepare
chroot_lfs_pacman /sources/scripts/chroot/6.16-binutils.sh
chroot_lfs /sources/scripts/chroot/6.16-binutils.sh

chroot_lfs_pacman /sources/scripts/chroot/6.17-gmp.sh
chroot_lfs /sources/scripts/chroot/6.17-gmp.sh

chroot_lfs_pacman /sources/scripts/chroot/6.18-mpfr.sh
chroot_lfs /sources/scripts/chroot/6.18-mpfr.sh

chroot_lfs_pacman /sources/scripts/chroot/6.19-mpc.sh
chroot_lfs /sources/scripts/chroot/6.19-mpc.sh

chroot_lfs_pacman /sources/scripts/chroot/6.20-shadow.sh
chroot_lfs /sources/scripts/chroot/6.20-shadow.sh

chroot_lfs /sources/scripts/chroot/6.21-gcc.sh prepare
chroot_lfs_pacman /sources/scripts/chroot/6.21-gcc.sh
chroot_lfs /sources/scripts/chroot/6.21-gcc.sh
chroot_lfs /sources/scripts/chroot/6.21-gcc.sh post-install

chroot_lfs_pacman /sources/scripts/chroot/6.22-bzip2.sh
chroot_lfs /sources/scripts/chroot/6.22-bzip2.sh

chroot_lfs_pacman /sources/scripts/chroot/6.23-pkg-config.sh
chroot_lfs /sources/scripts/chroot/6.23-pkg-config.sh

chroot_lfs_pacman /sources/scripts/chroot/6.24-ncurses.sh
chroot_lfs /sources/scripts/chroot/6.24-ncurses.sh

chroot_lfs_pacman /sources/scripts/chroot/6.25-attr.sh
chroot_lfs /sources/scripts/chroot/6.25-attr.sh

chroot_lfs_pacman /sources/scripts/chroot/6.26-acl.sh
chroot_lfs /sources/scripts/chroot/6.26-acl.sh

chroot_lfs_pacman /sources/scripts/chroot/6.27-libcap.sh
chroot_lfs /sources/scripts/chroot/6.27-libcap.sh

chroot_lfs_pacman /sources/scripts/chroot/6.28-sed.sh
chroot_lfs /sources/scripts/chroot/6.28-sed.sh

chroot_lfs_pacman /sources/scripts/chroot/6.29-psmisc.sh
chroot_lfs /sources/scripts/chroot/6.29-psmisc.sh

chroot_lfs_pacman /sources/scripts/chroot/6.30-iana-etc.sh
chroot_lfs /sources/scripts/chroot/6.30-iana-etc.sh

chroot_lfs_pacman /sources/scripts/chroot/6.31-bison.sh
chroot_lfs /sources/scripts/chroot/6.31-bison.sh

chroot_lfs_pacman /sources/scripts/chroot/6.32-flex.sh
chroot_lfs /sources/scripts/chroot/6.32-flex.sh

chroot_lfs_pacman /sources/scripts/chroot/6.33-grep.sh
chroot_lfs /sources/scripts/chroot/6.33-grep.sh

chroot_lfs_pacman /sources/scripts/chroot/6.34-bash.sh
chroot_lfs /sources/scripts/chroot/6.34-bash.sh


