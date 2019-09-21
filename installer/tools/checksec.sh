#!/bin/bash
#
# checksec.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/slimm609/checksec.sh
  # License: https://github.com/slimm609/checksec.sh/blob/master/LICENSE.txt
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/slimm609/checksec.sh
  cd checksec.sh/
  cp -f ./checksec /usr/local/bin/checksec.sh
}

update() {
  cd ${INSTALL_DIR}/tools/checksec.sh/
  git pull
  cp -f ./checksec /usr/local/bin/checksec.sh
}

test() {
  if [ ! -x /usr/local/bin/checksec.sh ] ; then
    echo "Error: failed to setup checksec.sh."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 checksec
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

exit 0
#__END__
