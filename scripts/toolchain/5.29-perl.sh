#!/bin/bash
set -e

if [[ ! -f $BUILDDIR/.perl-done ]];then
    pushd $BUILDDIR;
    perl=$(grep perl /sources/wget-list | sed 's/^.*perl/perl/');

    tar -xf /sources/$perl
    cd ${perl/.tar*}

    sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
    
    make

    cp -v perl cpan/podlators/scripts/pod2man /tools/bin
    mkdir -pv /tools/lib/perl5/5.28.0
    cp -Rv lib/* /tools/lib/perl5/5.28.0

    cd $BUILDDIR
    rm -rf ${perl/.tar*}
    popd
    unset perl
    touch $BUILDDIR/.perl-done
fi
