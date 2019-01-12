#!/bin/bash
set -e

pathappend /tools/bin

pushd /srv/pacman/recipes/Extra/libssh2
. PKGBUILD
PKGDEST=/srv/pacman/repos/Extra \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --asdeps --syncdeps --rmdeps --noconfirm
popd