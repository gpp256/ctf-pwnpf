#!/bin/bash
#
# xrop.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf


# Sub-Routines
install() {
  # Source : https://github.com/acama/xrop
  # License: GPL
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/acama/xrop
  cd xrop/
  git submodule update --init --recursive
  make install
}

update() {
  cd ${INSTALL_DIR}/tools/xrop/
  git pull
  make install
}

test() {
  if [ ! -x /usr/local/bin/xrop ] ; then
    echo "Error: failed to setup xrop."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 xrop
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
