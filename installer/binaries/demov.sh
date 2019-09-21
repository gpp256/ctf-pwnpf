#!/bin/sh
#
# demov.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
if [ $# -ne 1 ] ; then
echo "Usage: ./$0 file" ; exit 1
fi
demov -g ${1}.dot $1
cat ${1}.dot | dot -Tpng > ${1}.png
