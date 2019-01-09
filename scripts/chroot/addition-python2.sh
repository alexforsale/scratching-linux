#!/bin/bash
set -e

pathappend /tools/bin

pushd /srv/pacman/recipes/Python-extra/python2
. PKGBUILD
PKGDEST=/srv/pacman/repos/Python-extra \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --asdeps --syncdeps --rmdeps --noconfirm
popd
