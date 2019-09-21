#!/bin/bash
#
# test.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# check OSS
for f in `find ../tools -executable -type f 2>/dev/null`; do
	$f test
done

if [ x$INSTALL_DEMOV = xyes ] ; then
  # check z3
  bash -x ../tools/z3.sh test
  # check keystone
  bash -x ../tools/keystone.sh test
  # check capstone
  bash -x ../tools/capstone.sh test
  # check demov
  bash -x ../tools/demov.sh test
fi

if [ x$INSTALL_HOW2HEAP = xyes ] ; then
  # check how2heap
  bash -x ../tools/how2heap.sh test
fi

if [ x$INSTALL_ZERATOOL = xyes ] ; then
  # check zeratool
  bash -x ../tools/zeratool.sh test
fi

exit 0
#__END__
