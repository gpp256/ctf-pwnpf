#!/bin/bash
#
# ropgadget.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/JonathanSalwan/ROPgadget
  # License: BSD
  #   You are bound to the license agreement included in respective files.
  pip install capstone
  pip install ropgadget
  ROPgadget -v
}

update() {
  pip install -U capstone
  pip install -U ropgadget
  ROPgadget -v
}

test() {
  if [ ! -x /opt/ctf/tools/pyenv/shims/ROPgadget ] ; then
    echo "Error: failed to setup ROPgadget."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 ropgadget
======================================================
EOL

RET=0
source ~/.bashrc
export PYENV_ROOT=/opt/ctf/tools/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv rehash
pyenv local 2.7.16
case "$1" in
  install) install ; RET=$? ;;
  update)  update ; RET=$? ;;
  test)  test || RET=$? ;;
  *) echo "Usage: $0 {install|update}"; exit 1
esac

exit $RET
#__END__
