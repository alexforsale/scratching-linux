#!/bin/bash

if [[ ! -f $BUILDDIR/.strip-done ]];then

    strip --strip-debug /tools/lib/* &>/dev/null
    /usr/bin/strip --strip-unneeded /tools/{,s}bin/* # &>/dev/null

    rm -rf /tools/{,share}/{info,man,doc} # &>/dev/null

    find /tools/{lib,libexec} -name \*.la -delete #&>/dev/null
    touch $BUILDDIR/.strip-done
fi
