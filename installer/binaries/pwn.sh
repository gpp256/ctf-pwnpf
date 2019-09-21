#!/bin/sh
#
# pwn.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
if [ $# -ne 1 ] ; then
echo "Usage: ./$0 file"; exit 1;
fi
# https://github.com/akiym/akitools
AKITOOLS_DIR=/opt/ctf/tools/akitools
# https://gpp256.zapto.org/cgit/cgit.cgi/ctf-tools/
CTFTOOLS_DIR=/opt/ctf/tools/ctf-tools

file $1
# https://github.com/slimm609/checksec.sh
checksec.sh --file=$1
strings -tx -a $1 > str
readelf -r $1 >> info
${AKITOOLS_DIR}/gadgets $1 >> info
${AKITOOLS_DIR}/rodata2od $1 2>/dev/null

if [ -r libc ] ; then
# https://github.com/Escapingbug/get_main_arena
#main_arena_offset libc 2>&1 >> info
# https://github.com/david942j/one_gadget
one_gadget libc >> info
fi

# https://github.com/acama/xrop
echo "-- xrop --" >> info
xrop -n $1 >> info
echo "-- readelf -S --" >> info
readelf -S $1 >> info
echo "-- objdump -s -j.dynamic --" >> info
objdump -s -j.dynamic $1 >> info

# https://github.com/kirschju/demovfuscator
#if [ -x /usr/local/bin/demov.sh ] ; then
#/usr/local/bin/demov.sh $1 2>/dev/null
#fi

cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/pwntools.pm .
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/template/getaddr.pl .
perl -I. getaddr.pl >>info
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/template/bof_x86-64_libc_csu_init2.pl try.pl
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/template/hof_x86-64_house_of_spirit.pl heap.pl
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/template/udp_attack.pl .
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/template/fsb_x86-64_hhn_aslr.pl .
cp ${CTFTOOLS_DIR}/pwn/perl_pwntools/asm/readdir_x86-64.s readdir.s
cp ${AKITOOLS_DIR}/disastobin .
cp ${AKITOOLS_DIR}/tohex .
#cp /opt/ctf/tools/check_elf/gdbconf/samples/gdb02.conf ./gdb.conf

# https://github.com/david942j/seccomp-tools
#if [ -x /usr/local/bin/seccomp-tools ] ; then
#timeout 10 seccomp-tools dump ./$1 >> info
#fi
echo FLAG_GGGGGGGGGGGGGGGGG > flag
