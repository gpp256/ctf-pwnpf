#!/bin/bash
#
# pwntools.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/arthaud/python3-pwntools
  # License: BSD系 https://github.com/arthaud/python3-pwntools/blob/master/LICENSE-pwntools.txt
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  wget -q https://github.com/jgm/pandoc/releases/download/2.7.1/pandoc-2.7.1-1-amd64.deb
  dpkg -i pandoc-2.7.1-1-amd64.deb
  rm pandoc-2.7.1-1-amd64.deb
  pip install git+https://github.com/arthaud/python3-pwntools.git
}

update() {
  pip3 install -U git+https://github.com/arthaud/python3-pwntools.git
}

test() {
  cd $HOME
  pyenv local 3.7.3
  python -c 'import pwn; exit(0)' >/dev/null 2>&1
  result=$?
  [ $result -eq 0 ] || echo "Error: failed to setup pwntools."
  return $result
}

# Main Routine
cat <<EOL
======================================================
 pwntools
======================================================
EOL

RET=0
source ~/.bashrc
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
