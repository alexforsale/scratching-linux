#!/bin/bash
set -e

pathappend /tools/bin

pushd /srv/pacman/recipes/Main/make-ca
. PKGBUILD
PKGDEST=/srv/pacman/repos/Main \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --asdeps --syncdeps --rmdeps --noconfirm
popd
