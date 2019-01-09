#!/bin/bash
set -e

# update pacman repositories
# with all the packages installed so far
pushd /srv/pacman/repos
repos=($(ls /srv/pacman/recipes))
for r in ${repos[@]/scripts};do
    pushd $r
    files=($(find . -type f -not -name "${r}.*" -printf '%P\n'))
    for f in ${files[@]};do
        if [[ ${#files[@]} -ne 0 ]];then
        repo-add --new /srv/pacman/repos/${r}/${r}.db.tar.gz ${f}
        fi
    done
    unset files
    popd
done
popd

[[ ! -f /usr/local/bin/make_package.sh ]] && sudo cp /srv/pacman/recipes/scripts/make_package.sh /usr/local/bin/make_package &&
    sudo chmod +x /usr/local/bin/make_package

# use the new pacman config files
sudo cp -v /etc/pacman.conf.pacnew /etc/pacman.conf
sudo cp -v /etc/makepkg.conf.pacnew /etc/makepkg.conf

# user makepkg.conf for pacman
if [[ ! -f ~/.makepkg.conf ]];then
echo "SRCDEST=/sources" > ~/.makepkg.conf
echo "PACKAGER=\"pacman <pacman@lfs.localdomain>\"" >> ~/.makepkg.conf
fi

# permission for ~/.gnupg
sudo chmod 700 ~/.gnupg -R
