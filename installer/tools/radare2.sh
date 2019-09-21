#!/bin/bash
#
# radare2.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/radare/radare2.git
  # License: GPLv3
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/radare/radare2.git
  cd radare2/
  ./sys/install.sh --with-capstone5
  [ $? -eq 0 ] || ./sys/install.sh --with-capstone5
  r2 -v
}

update() {
  cd ${INSTALL_DIR}/tools/radare2/
  git pull
  ./sys/install.sh --with-capstone5
  r2 -v
}

test() {
  if [ ! -x /usr/bin/r2 ] ; then
    echo "Error: failed to setup radare2."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 radare2
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
