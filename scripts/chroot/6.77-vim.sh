#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.chroot-vim-done ]];then
    pushd $BUILDDIR
    vim=$(grep vim- /sources/wget-list | grep tar | sed 's/^.*vim-/vim-/');
    tar -xf /sources/$vim;
    cd vim$(echo ${vim/.tar*} | sed 's/[^0-9]*//g')
    #cd ${vim/.tar*}

    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
    ./configure --prefix=/usr
    make
    [[ ${TEST} -eq 1 ]] && LANG=en_US.UTF-8 make -j1 test &> vim-test.log
    make install
    ln -sv vim /usr/bin/vi
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done
    ln -sv ../vim/vim81/doc /usr/share/doc/vim-8.1

    cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

    cd $BUILDDIR
    rm -rf vim$(echo ${vim/.tar*} | sed 's/[^0-9]*//g') #${vim/.tar*}
    popd
    unset vim
    touch $BUILDDIR/.chroot-vim-done
fi
