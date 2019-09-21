#!/bin/sh
#
# preinstall.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ./setup.conf

cat <<EOL
======================================================
 Pre Installation Scripts
======================================================
EOL

if [ x$INSTALL_DEMOV = xyes ] ; then
  # setup z3
  bash -x tools/z3.sh install 2>&1 >> install.log
  
  # setup keystone
  bash -x tools/keystone.sh install 2>&1 >> install.log
  
  # setup capstone
  bash -x tools/capstone.sh install 2>&1 >> install.log
fi

if [ x$INSTALL_HOW2HEAP = xyes ] ; then
  # setup how2heap
  bash -x tools/how2heap.sh install 2>&1 >> install.log
fi

if [ x$INSTALL_ZERATOOL = xyes ] ; then
  # setup zeratool
  bash -x tools/zeratool.sh install 2>&1 >> install.log
fi

exit 0
#__END__
