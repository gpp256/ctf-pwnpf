#!/bin/bash
#
# keystone.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/keystone-engine/keystone.git 
  # License: GPL
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/keystone-engine/keystone.git
  cd keystone/
  mkdir build
  cd build
  pyenv local 2.7.16
  ../make-share.sh
  make install
  ldconfig
  cd ..
  rm -rf build
}

update() {
  cd ${INSTALL_DIR}/tools/keystone/
  git pull
  mkdir build
  cd build
  pyenv local 2.7.16
  ../make-share.sh
  make install
  ldconfig
  cd ..
  rm -rf build
}

test() {
  if [ ! -r /usr/local/lib/libkeystone.so ] ; then
    echo "Error: failed to setup keystone."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 keystone
======================================================
EOL

RET=0
source ~/.bashrc
case "$1" in
  install) install ; RET=$? ;;
  update)  update ; RET=$? ;;
  test)  test || RET=$? ;;
  *) echo "Usage: $0 {install|update}"; exit 1
esac

exit $RET
#__END__
