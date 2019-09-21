#!/bin/bash
#
# zeratool.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  # Source : https://github.com/ChrisTheCoolHut/Zeratool
  # License: GPLv3
  #   You are bound to the license agreement included in respective files.
  cd ${INSTALL_DIR}/tools/
  git clone https://github.com/ChrisTheCoolHut/Zeratool
  cd Zeratool/
  #pip install virtualenv virtualenvwrapper
  #pip install --upgrade pip
  #export WORKON_HOME=~/virtualenvs
  #virtualenv --no-site-packages zeratool

  cd zeratool
  pyenv local 2.7.16
  source bin/activate

  gem install one_gadget
  pip install angr==7.8.2.21 cffi==1.7.0 future==0.16.0 pycparser==2.18  IPython==5.0 r2pipe psutil timeout_decorator pwn
  pip install IPython==5.0 r2pipe psutil timeout_decorator
  pip install pathlib
  pip install ropper

  wget -q https://files.pythonhosted.org/packages/0b/3a/9fc0c62bd74583137a8bbc3c8020d6a8234b9cf8bc1e99fe929688b19093/filebytes-0.9.20.tar.gz
  tar xvzf filebytes-0.9.20.tar.gz
  cd filebytes-0.9.20/
  pyenv local 2.7.16
  perl -pi.backup -e "s/^version\s=\s[^\n]+/version=\'0\.9\.20\'/;" setup.py
  python setup.py install
  
  cat <<EOL >> /usr/local/bin/zeratool.sh
#!/bin/bash
if [ \$# -ne 1 ] ; then
  echo "Usage: \$0 file"; exit 1
fi
export WORKON_HOME=\$HOME/virtualenvs/
cd /opt/ctf/tools/Zeratool/zeratool
source bin/activate
cd ..
echo FLAG_GGGGGGGGGGGGGGGGG > flag1.txt
python zeratool.py \$1
exit \$?
EOL
  chmod 755 /usr/local/bin/zeratool.sh
}

update() {
  cd ${INSTALL_DIR}/tools/Zeratool/
  git pull
}

test() {
  if [ ! -r /opt/ctf/tools/Zeratool/zeratool.py ] ; then
    echo "Error: failed to setup Zeratool."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 zeratool
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
