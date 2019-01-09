#!/bin/bash
set -e

pathappend /tools/bin

sudo mkdir -p $HOME
sudo chown -R pacman:pacman $HOME
mkdir -p ~/.gnupg

pushd /srv/pacman/recipes/Extra/gpgme
. PKGBUILD
PKGDEST=/srv/pacman/repos/Extra \
       SRCDEST=/sources makepkg --skipinteg --nocheck --clean --cleanbuild --needed \
       --install --asdeps --syncdeps --rmdeps --noconfirm
popd
