#!/bin/bash
#
# xorsearch.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://blog.didierstevens.com/programs/xorsearch/
  # License: public domain
  V=V1_11_2
  cd ${INSTALL_DIR}/tools/
  wget -q --no-check-certificate http://didierstevens.com/files/software/XORSearch_${V}.zip
  mkdir xorsearch
  cd xorsearch/
  unzip ../XORSearch_${V}.zip
  gcc -o xorsearch XORSearch.c
  cp xorsearch /usr/local/bin/
  rm ../XORSearch_${V}.zip
}

update() {
  U=`curl -s https://blog.didierstevens.com/programs/xorsearch/ | 
    awk -F '"' '/files\/software\/XORSearch_V/ {print $2}' 2>/dev/null`
  cd ${INSTALL_DIR}/tools/
  wget -q --no-check-certificate $U
  mkdir -p xorsearch
  cd xorsearch/
  unzip -o ../XORSearch_*.zip
  gcc -o xorsearch XORSearch.c
  cp xorsearch /usr/local/bin/
  rm ../XORSearch_*.zip
}

test() {
  if [ ! -x /usr/local/bin/xorsearch ] ; then
    echo "Error: failed to setup xorsearch."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 xorsearch
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
