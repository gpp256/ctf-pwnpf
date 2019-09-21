#!/bin/bash
#
# demov.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/kirschju/demovfuscator
  # License: BSD 2-Clause "Simplified" License
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  if [ x$INSTALL_DEMOV = xyes ] ; then
    git clone https://github.com/kirschju/demovfuscator
    cd demovfuscator/
    make
    cp -f demov /usr/local/bin/
    make clean
  fi
}

update() {
  if [ x$INSTALL_DEMOV = xyes ] ; then
    cd ${INSTALL_DIR}/tools/demovfuscator/
    git pull
    make
    cp -f demov /usr/local/bin/
    make clean
  fi
}

test() {
  if [ ! -r /usr/local/bin/demov ] ; then
    echo "Error: failed to setup demov."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 demov
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
