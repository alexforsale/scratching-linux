#!/bin/bash
set -e

pathappend /tools/bin

pushd /srv/pacman/recipes/Main/pacman
. PKGBUILD
PKGDEST=/srv/pacman/repos/Main \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --syncdeps --rmdeps --noconfirm
popd
