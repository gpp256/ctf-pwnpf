#!/bin/bash
#
# main_arena.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/danigargu/heap-viewer.git
  # License: GPLv3
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/danigargu/heap-viewer.git
  cd heap-viewer/utils/get_main_arena
  make
  cp main_arena_offset /usr/local/bin/
  make clean
  
  # Source : https://github.com/bash-c/main_arena_offset.git
  # License: Apache License 2.0
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/bash-c/main_arena_offset.git
  cd main_arena_offset/
  cp main_arena /usr/local/bin/
}

update() {
  cd ${INSTALL_DIR}/tools/heap-viewer/utils/get_main_arena
  git pull
  make 
  cp main_arena_offset /usr/local/bin/
  make clean

  cd ${INSTALL_DIR}/tools/main_arena_offset/
  git pull
  cp main_arena /usr/local/bin/
}

test() {
  if [ ! -x /usr/local/bin/main_arena ] ; then
    echo "Error: failed to setup main_arena."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 main_arena
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
