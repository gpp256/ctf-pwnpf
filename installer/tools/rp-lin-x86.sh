#!/bin/bash
#
# rp-lin-x86.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com//0vercl0k/rp
  # License: GPLv3
  #   You are bound to the license agreement included in respective files.
  wget -q --no-check-certificate https://github.com/downloads/0vercl0k/rp/rp-lin-x64
  wget -q --no-check-certificate https://github.com/downloads/0vercl0k/rp/rp-lin-x86
  chmod +x rp-lin-x64 rp-lin-x86 
  mv rp-lin-x64 rp-lin-x86 /usr/local/bin
}

update() {
  install
}

test() {
  if [ ! -x /usr/local/bin/rp-lin-x86 ] ; then
    echo "Error: failed to setup rp-lin-x86."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 rp-lin-x86
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
