#!/bin/bash
set -e

pathappend /tools/bin

pushd /srv/pacman/recipes/Main/which
. PKGBUILD
PKGDEST=/srv/pacman/repos/Main \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --asdeps --syncdeps --rmdeps --noconfirm
popd
