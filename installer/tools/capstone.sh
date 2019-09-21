#!/bin/bash
#
# capstone.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/aquynh/capstone.git
  # License: BSD系
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/aquynh/capstone.git
  cd capstone/
  sh make.sh
  sh make.sh install
}

update() {
  cd ${INSTALL_DIR}/tools/capstone/
  git pull
  sh make.sh
  sh make.sh install
}

test() {
  if [ ! -r /usr/lib/libcapstone.so.5 ] ; then
    echo "Error: failed to setup capstone."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 capstone
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
