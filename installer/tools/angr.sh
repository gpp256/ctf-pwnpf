#!/bin/bash
#
# angr.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/angr
  # License: BSD 2-Clause "Simplified" License
  #   You are bound to the license agreement included in respective files.
  pip install angr
}

update() {
  pip install -U angr
}

test() {
  cd $HOME
  python -c 'import angr; exit(0)' >/dev/null 2>&1
  result=$?
  [ $result -eq 0 ] || echo "Error: failed to setup angr."
  return $result
}

# Main Routine
cat <<EOL
======================================================
 angr
======================================================
EOL

RET=0
source ~/.bashrc
cd /opt/ctf/tools
export PYENV_ROOT=/opt/ctf/tools/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv rehash
pyenv global 3.7.3
case "$1" in
  install) install ; RET=$? ;;
  update)  update ; RET=$? ;;
  test)  test || RET=$? ;;
  *) echo "Usage: $0 {install|update}"; exit 1
esac
exit $RET
#__END__
