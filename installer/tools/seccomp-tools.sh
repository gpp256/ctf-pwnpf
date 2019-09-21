#!/bin/bash
#
# seccomp-tools.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/david942j/seccomp-tools 
  # License: MIT
  #   You are bound to the license agreement included in respective files.

  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/david942j/seccomp-tools
  cd seccomp-tools/
  gem install seccomp-tools
}

update() {
  cd ${INSTALL_DIR}/tools/seccomp-tools/
  git pull
  gem update seccomp-tools
}

test() {
  if [ ! -x /home/guru/.rbenv/shims/seccomp-tools ] ; then
    echo "Error: failed to setup seccomp-tools."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 seccomp-tools
======================================================
EOL

RET=0
source ~/.bashrc
export PATH=${INSTALL_DIR}/tools/rbenv/bin:$PATH
eval "$(rbenv init -)"
rbenv rehash
rbenv global 2.5.1
case "$1" in
  install) install ; RET=$? ;;
  update)  update ; RET=$? ;;
  test)  test || RET=$? ;;
  *) echo "Usage: $0 {install|update}"; exit 1
esac

exit $RET
#__END__
