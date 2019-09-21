ctf-pwnpf
============

ctf-pwnpf is an analysis platform for learning Pwn/Reversing.

Quick Start
------------

To start, run the following commands.

    e.g.
    $ vi docker.conf
    $ cat docker.conf
    IMAGE_NAME=pwn-pf
    VM_NAME=pwn3
    TAG=3.1
    CTF_DATA_DIR=/opt/docker/pwnpf-data
    
    $ sh docker.sh
    Usage: docker.sh {build|run|clean|status|update}
    $ sh docker.sh build
    $ sh docker.sh run # docker run -v ${CTF_DATA_DIR}:/opt/ctf/data ...(snip)
    $ sh docker.sh status

Links
--------

* https://github.com/gpp256/ctf-writeups

License
----------

You are bound to the license agreement included in respective files.

