#!/bin/bash
#
# peda.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
set -x
cd `dirname $0`
. ../setup.conf

# Sub-Routines
install() {
  cd ${INSTALL_DIR}/tools
  # Source : https://github.com/longld/peda.git
  # License: CC BY-NC-SA 3.0: http://creativecommons.org/licenses/by-nc-sa/3.0/
  #   You are bound to the license agreement included in respective files.
  git clone https://github.com/longld/peda.git 
  # Source : https://github.com/scwuaptx/Pwngdb
  # License: GPLv3
  #   You are bound to the license agreement included in respective files.
  git clone https://github.com/scwuaptx/Pwngdb.git 
  #cp Pwngdb/.gdbinit .

  cat <<EOL > ~/.gdbinit
source ${INSTALL_DIR}/tools/peda/peda.py
source ${INSTALL_DIR}/tools/Pwngdb/pwngdb.py
source ${INSTALL_DIR}/tools/Pwngdb/angelheap/gdbinit.py

define hook-run
python
import angelheap
angelheap.init_angelheap()
end
end

#add-auto-load-safe-path /home/guru/work/golang/go/src/runtime/runtime-gdb.py

# コマンド履歴を保存する
set history save on
set history size 10000
set history filename ~/.gdb_history

# listコマンドで表示する行数
#set listsize 25

# リモートホストのlibcをロードしてデバッグしたい場合
#set solib-search-path ./libc.so.6

# 配列の要素を全て表示する
set print elements 0

# 構造体のメンバを1行ずつ表示できる
set print pretty on

# quitコマンドで終了するときに確認しない
define hook-quit
    set confirm off
end

set disassembly-flavor intel

#set follow-fork-mode child
#source ${INSTALL_DIR}/tools/check_elf/gdbconf/customcmd/x86.gdb
#source ${INSTALL_DIR}/tools/check_elf/gdbconf/customcmd/x86-64.gd
#set height 0
EOL
}

update() {
  cd ${INSTALL_DIR}/tools/peda/
  git pull
  cd ${INSTALL_DIR}/tools/Pwngdb
  git pull
}

test() {
  if [ ! -r /opt/ctf/tools/peda/peda.py ] ; then
    echo "Error: failed to setup peda."; return 64
  fi
  return 0
}

# Main Routine
cat <<EOL
======================================================
 peda+Pwngdb
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
