#!/bin/bash
#
# shellnoob.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/reyammer/shellnoob.git
  # License: MIT
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/reyammer/shellnoob.git
  cd shellnoob/
  export PYENV_ROOT=${INSTALL_DIR}/pyenv
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  pyenv rehash
  pyenv global 3.7.3
  echo '' | python shellnoob.py --install
  which snoob
}

update() {
  cd ${INSTALL_DIR}/tools/shellnoob/
  git pull
  echo '' | python shellnoob.py --install
}

test() {
  if [ ! -x /usr/local/bin/snoob ] ; then
    echo "Error: failed to setup shellnoob."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 shellnoob
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
