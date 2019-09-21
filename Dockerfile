#
# Dockerfile
#
# Copyright (c) 2019 gpp256
# This software is distributed under the MIT License.(./MIT-LICENSE.txt)
#
#FROM ubuntu:18.04
FROM ubuntu:18.04
MAINTAINER gpp256@noraneco
LABEL Project="noraneco-pwn-pf" Version="3.1"

WORKDIR /root/work
COPY installer /root/work/installer/
RUN sh -x /root/work/installer/start.sh

COPY entrypoint.sh /root/work/
ENTRYPOINT ["bash", "-c", "/root/work/entrypoint.sh"]
