#!/bin/bash
#
# libformatstr.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/hellman/libformatstr.git
  # License: MIT
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/hellman/libformatstr.git
  cd libformatstr/
  pyenv local 2.7.16
  python setup.py install
}

update() {
  cd ${INSTALL_DIR}/tools/libformatstr/
  pyenv local 2.7.16
  git pull
  python setup.py install
}

test() {
  cd ${INSTALL_DIR}/tools/libformatstr/
  pyenv local 2.7.16
  python -c \
    'from libformatstr import FormatStr; fmt=FormatStr();exit(0)' \
    >/dev/null 2>&1
  result=$?
  [ $result -eq 0 ] || echo "Error: failed to setup libformatstr."
  return $result
}

# Main Routine
cat <<EOL
======================================================
 libformatstr
======================================================
EOL

RET=0
source ~/.bashrc
export PYENV_ROOT=/opt/ctf/tools/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv rehash
case "$1" in
  install) install ; RET=$? ;;
  update)  update ; RET=$? ;;
  test)  test || RET=$? ;;
  *) echo "Usage: $0 {install|update}"; exit 1
esac

exit $RET
#__END__
