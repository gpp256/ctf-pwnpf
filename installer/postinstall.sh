#!/bin/sh
#
# postinstall.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ./setup.conf

cat <<EOL
======================================================
 Post Installation Scripts
======================================================
EOL

# setup tmux
tar -C /root -xzf /root/work/installer/binaries/tmux_conf.tar.gz
chown -R root:root ~/.tmux.conf ~/.tmux

# extract ctf-tools.tar.gz
tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/ctf-tools.tar.gz

# copy all-{objdump,gdb}
#cp -f /root/work/installer/binaries/all-gdb /usr/local/bin/
#cp -f /root/work/installer/binaries/all-objdump /usr/local/bin/
#(cd /usr/lib/x86_64-linux-gnu/; ln -s libpython2.7.so.1.0 libpython2.6.so.1.0)

# copy socat.sh
cp -f /root/work/installer/binaries/socat.sh /usr/local/bin/

# copy pwn.sh
cp -f /root/work/installer/binaries/pwn.sh /usr/local/bin/

# copy demov.sh
#cp -f /root/work/installer/binaries/demov /usr/local/bin/
cp -f /root/work/installer/binaries/demov.sh /usr/local/bin/

# extract libcdb.tar.gz
tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/libcdb.tar.gz
(cd ${INSTALL_DIR}/tools/libcdb; bash -x install.sh)
rm -f /root/work/installer/binaries/libcdb.tar.gz

# extract qemu
#tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/qemu_statics.tar.gz
#rm -f /root/work/installer/binaries/qemu_statics.tar.gz

# extract pwn_examples
cd ${INSTALL_DIR}/tools
ln -s ctf-tools/pwn/pwn_examples .
(cd ${INSTALL_DIR}/tools/pwn_examples/binaries; tar xzf /root/work/installer/binaries/exercise00.tar.gz)
(cd ${INSTALL_DIR}/tools/pwn_examples/binaries; tar xzf /root/work/installer/binaries/exercise08.tar.gz)
(cd ${INSTALL_DIR}/tools/pwn_examples/binaries; tar xzf /root/work/installer/binaries/exercise09.tar.gz)

# extract cross.tar.gz
#tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/cross.tar.gz

# copy decompiler.sh
# egrep -e Project -e Homepage /usr/local/bin/decompiler.sh
# Project:   retdec-sh
# Homepage:  https://github.com/s3rvac/retdec-sh
cp -f /root/work/installer/binaries/decompiler.sh /usr/local/bin/

# extract momo-tech.tar.gz
#tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/momo-tech.tar.gz

# extract check_elf.tar.gz
#tar -C ${INSTALL_DIR}/tools -xzf /root/work/installer/binaries/check_elf.tar.gz

# extract defcon2019-speedrun.tar.gz
#mkdir -p /home/guru/work
#tar -C /home/guru/work -xzf /root/work/installer/binaries/defcon2019-speedrun.tar.gz

# create .vimrc
cat <<EOL > /root/.vimrc
syntax on
set ai
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,iso-2022-jp,euc-jp-ms,euc-jp
set paste
set visualbell

filetype plugin on
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

nnoremap <C-h> <C-w><<CR>
nnoremap <C-l> <C-w>><CR>
nnoremap <C-k> <C-w>-<CR>
nnoremap <C-j> <C-w>+<CR>
EOL

chown -R guru:guru ${INSTALL_DIR}
cd /home/guru
cp -r /root/.tmux .
cp -r /root/.tmux.conf .
cp -r /root/.vimrc .
cp -r /root/.gdbinit .
cp -r /root/.bashrc .
chown -R guru:guru /home/guru

exit 0
#__END__
