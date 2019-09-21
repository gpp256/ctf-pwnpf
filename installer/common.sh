#!/bin/sh
#
# common.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ./setup.conf

mkdir -p ${INSTALL_DIR}/tools

if [ x$INSTALL_TARGET != "xdocker" ] ; then
  hostnamectl set-hostname $VM_HOSTNAME
fi

if [ "x$DISABLE_DNS" = "xYES" ] ; then
  perl -pi.backup_ctf -e 's/^hosts:.+$/hosts: files myhostname\n/; ' /etc/nsswitch.conf
fi

# configuration for proxy
if [ x$WEB_PROXY = xON ] ; then
  echo "export http_proxy=http://${PROXY_IP_ADDR}:${PROXY_PORT}" >> ~/.bashrc
  echo "export https_proxy=https://${PROXY_IP_ADDR}:${PROXY_PORT}" >> ~/.bashrc
  echo "export no_proxy=127.0.0.1,localhost" >> ~/.bashrc
  cat <<EOL > /etc/apt/apt.conf
Acquire::ftp::proxy "ftp://${PROXY_IP_ADDR}:${PROXY_PORT}/";
Acquire::http::proxy "http://${PROXY_IP_ADDR}:${PROXY_PORT}/";
Acquire::https::proxy "https://${PROXY_IP_ADDR}:${PROXY_PORT}/";
EOL
fi

# install oss packages
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NOWARNINGS=yes
dpkg --add-architecture i386
apt-get update
apt-get install -y build-essential linux-headers-generic
apt-get install -y git net-tools vim gdb gdbserver socat binutils nasm \
  python git autoconf libtool make strace ltrace curl wget \
  libreadline-dev libbz2-dev libsqlite3-dev libssl-dev zlib1g-dev libffi-dev \
  sudo openssh-server man netcat gawk lsb-release tcpdump libpython2.7 \
  unzip libc6-dev-i386 cmake clang perl-doc libseccomp-dev \
  libbase58-dev ht libncurses5 libncurses5-dev libncursesw5 \
  texinfo tmux
apt-get install -y libc6:i386 libstdc++6:i386

# set timezone
apt-get install -y tzdata 
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# configuration for git
if [ x$WEB_PROXY = xON ] ; then
  git config --global http.proxy ${PROXY_IP_ADDR}:$PROXY_PORT
fi
git config --global http.sslVerify false

# setup pyenv
cd ${INSTALL_DIR}/tools
git clone https://github.com/yyuu/pyenv.git
export PYENV_ROOT=${INSTALL_DIR}/tools/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv install 2.7.16
# for ubuntu 15.04
if lsb_release -r -s | grep -q '15.' ; then
  wget -q --no-check-certificate https://www.openssl.org/source/openssl-1.0.2s.tar.gz
  tar xvzf openssl-1.0.2s.tar.gz
  cd openssl-1.0.2s
  ./config shared zlib
  make install
  make clean
  cd ..
  rm openssl-1.0.2s.tar.gz
  if grep -q /usr/local/ssl/bin ~/.bashrc ; then
    :
  else
    echo 'export PATH="/usr/local/ssl/bin:$PATH"' >> ~/.bashrc
    echo 'export PKG_CONFIG_PATH=/usr/local/ssl/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
    echo /usr/local/ssl/lib > /etc/ld.so.conf.d/ssl.conf
    ldconfig
  fi
fi
pyenv install 3.7.3
pyenv global 3.7.3
pyenv rehash
if grep -q PYENV ~/.bashrc ; then
  :
else 
  echo 'export PYENV_ROOT=/opt/ctf/tools/pyenv' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# setup rbenv
cd /opt/ctf/tools/
git clone https://github.com/sstephenson/rbenv.git 
if grep -q rbenv ~/.bashrc ; then
  :
else
  echo "export PATH=${INSTALL_DIR}"'/tools/rbenv/bin:$PATH' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  export PATH=${INSTALL_DIR}/tools/rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi
git clone https://github.com/sstephenson/ruby-build.git /opt/ctf/tools/rbenv/plugins/ruby-build
/opt/ctf/tools/rbenv/plugins/ruby-build/install.sh

getent passwd guru>/dev/null 2>&1 || 
  useradd -d /home/guru -s /bin/bash -m -p `openssl passwd -1 'demodemo'` guru
usermod -G sudo guru

rm -rf /home/guru/.rbenv
rm -rf /root/.rbenv
(cd /home/guru; ln -s ${INSTALL_DIR}/tools/rbenv ./.rbenv)
(cd /root; ln -s ${INSTALL_DIR}/tools/rbenv ./.rbenv)
cp -f ~/.bashrc /home/guru/.bashrc
chown -R guru:guru /opt/ctf/tools/rbenv/
chown -R guru:guru /home/guru
{
su - guru
export PATH=${INSTALL_DIR}/tools/rbenv/bin:$PATH
eval "$(rbenv init -)"
rbenv install 2.5.1
rbenv rehash
rbenv global 2.5.1
exit
}
rbenv rehash
rbenv global 2.5.1

# setup jdk
#wget -q --no-check-certificate \
#  https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
#tar xzf openjdk-11.0.2_linux-x64_bin.tar.gz
#rm -f openjdk-11.0.2_linux-x64_bin.tar.gz
#export JAVA_HOME=${INSTALL_DIR}/tools/jdk-11.0.2
#export CLASSPATH=.:$JAVA_HOME/lib
#if grep -q JAVA_HOME ~/.bashrc ; then
#  :
#else
#  echo 'export JAVA_HOME=${INSTALL_DIR}/tools/jdk-11.0.2' >> ~/.bashrc
#  echo 'export CLASSPATH=.:$JAVA_HOME/lib' >> ~/.bashrc
#fi

exit 0
#__END__
