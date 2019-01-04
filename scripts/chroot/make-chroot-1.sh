#!/tools/bin/bash
set -e

bash $SCRIPTDIR/chroot/6.7-linux-api-headers.sh
bash $SCRIPTDIR/chroot/6.8-man-pages.sh
bash $SCRIPTDIR/chroot/6.9-glibc.sh
bash $SCRIPTDIR/chroot/6.10-Adjusting-the-Toolchain.sh
bash $SCRIPTDIR/chroot/6.11-zlib.sh
bash $SCRIPTDIR/chroot/6.12-file.sh
bash $SCRIPTDIR/chroot/6.13-readline.sh
bash $SCRIPTDIR/chroot/6.14-m4.sh
bash $SCRIPTDIR/chroot/6.15-bc.sh
bash $SCRIPTDIR/chroot/6.16-binutils.sh
bash $SCRIPTDIR/chroot/6.17-gmp.sh
bash $SCRIPTDIR/chroot/6.18-mpfr.sh
bash $SCRIPTDIR/chroot/6.19-mpc.sh
bash $SCRIPTDIR/chroot/6.20-shadow.sh
bash $SCRIPTDIR/chroot/6.21-gcc.sh
bash $SCRIPTDIR/chroot/6.22-bzip2.sh
bash $SCRIPTDIR/chroot/6.23-pkg-config.sh
bash $SCRIPTDIR/chroot/6.24-ncurses.sh
bash $SCRIPTDIR/chroot/6.25-attr.sh
bash $SCRIPTDIR/chroot/6.26-acl.sh
bash $SCRIPTDIR/chroot/6.27-libcap.sh
bash $SCRIPTDIR/chroot/6.28-sed.sh
bash $SCRIPTDIR/chroot/6.29-psmisc.sh
bash $SCRIPTDIR/chroot/6.30-iana-etc.sh
bash $SCRIPTDIR/chroot/6.31-bison.sh
bash $SCRIPTDIR/chroot/6.32-flex.sh
bash $SCRIPTDIR/chroot/6.33-grep.sh
bash $SCRIPTDIR/chroot/6.34-bash.sh

