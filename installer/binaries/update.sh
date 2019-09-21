#!/bin/bash
#
# update.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# update OSS
[ -r update.log ] && rm -f update.log
for f in `find ../tools -executable -type f 2>/dev/null`; do
	$f update >>update.log 2>&1
done

if [ x$INSTALL_DEMOV = xyes ] ; then
  # update z3
  bash -x ../tools/z3.sh update >> update.log 2>&1 
  # update keystone
  bash -x ../tools/keystone.sh update >> update.log 2>&1 
  # update capstone
  bash -x ../tools/capstone.sh update >> update.log 2>&1 
  # update demov
  bash -x ../tools/demov.sh update >> update.log 2>&1 
fi

if [ x$INSTALL_HOW2HEAP = xyes ] ; then
  # update how2heap
  bash -x ../tools/how2heap.sh update >> update.log 2>&1 
fi

if [ x$INSTALL_ZERATOOL = xyes ] ; then
  # update zeratool
  bash -x ../tools/zeratool.sh update >> update.log 2>&1 
fi

exit 0
#__END__
