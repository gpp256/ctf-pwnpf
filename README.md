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
    VM_NAME=pwnpf
    TAG=3.1
    CTF_DATA_DIR=/opt/docker/pwnpf-data
    
    $ sh docker.sh
    Usage: docker.sh {build|run|clean|status|update|create_image|test_image}
    $ sh docker.sh build
    $ sh docker.sh run # docker run -v ${CTF_DATA_DIR}:/opt/ctf/data ...(snip)
    $ sh docker.sh status
    
    $ docker exec -it pwnpf bash
    # cd /opt/ctf/tools/Zeratool
    # python zeratool.py challenges/bof1
    [+] Flag found:
    flag{y0u_g0t_1t}

Links
--------

* https://github.com/gpp256/ctf-writeups

License
----------
Copyright &copy; 2019 gpp256  
Distributed under the [MIT License][mit].  

[MIT]: https://github.com/gpp256/ctf-pwnpf/blob/master/LICENSE

