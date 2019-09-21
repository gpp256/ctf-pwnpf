#!/bin/bash
#
# how2heap.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source :https://github.com/shellphish/how2heap.git 
  # License: -
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools
  git clone https://github.com/shellphish/how2heap.git
  cd how2heap
  # bash glibc_build.sh 2.23 4
  bash glibc_build.sh 2.25 4
  bash glibc_build.sh 2.26 4
  find glibc_versions/
  rm -rf glibc_build glibc_src
  make
}

update() {
  cd ${INSTALL_DIR}/tools/how2heap/
  git pull
  make
}

test() {
  if [ ! -x /opt/ctf/tools/how2heap/glibc_versions/libc-2.26.so ] ; then
    echo "Error: failed to setup how2heap."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 how2heap
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
