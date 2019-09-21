#!/bin/sh
#
# start.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ./setup.conf
mkdir -p $INSTALL_DIR
echo == $(date '+%Y-%m-%d %H:%M:%S') == > install.log

# setup base-pf
bash -x ./common.sh 2>&1 >> install.log

# invoke pre-installation scripts
bash -x ./preinstall.sh >>install.log 2>&1

# setup OSS
for f in `find ./tools -executable -type f 2>/dev/null`; do
	$f install >>install.log 2>&1
done

# invoke post-installation scripts
bash -x ./postinstall.sh >>install.log 2>&1
exit 0
#__END__
