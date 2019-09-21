#!/bin/bash
#
# z3.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf


# Sub-Routines
install() {
  # Source : https://github.com/Z3Prover/z3.git
  # License: MIT
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/Z3Prover/z3.git
  cd z3
  pyenv local 2.7.16
  python scripts/mk_make.py
  cd build
  make
  PREFIX=/usr/local make -e install
  ldconfig
  cd ..
  rm -rf build
}

update() {
  cd ${INSTALL_DIR}/tools/z3/
  git pull
  pyenv local 2.7.16
  python scripts/mk_make.py
  cd build
  make
  PREFIX=/usr/local make -e install
  ldconfig
  cd ..
  rm -rf build
}

test() {
  /opt/ctf/tools/pyenv/shims/pip freeze | grep -q z3 2>/dev/null
  result=$?
  [ $result -eq 0 ] || echo "Error: failed to setup z3."
  return $result
}

# Main Routine
cat <<EOL
======================================================
 z3
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
