FROM python:3.9

MAINTAINER Alex Iankoulski <iankouls@amazon.com>

ARG http_proxy
ARG https_proxy
ARG no_proxy

ADD Container-Root /

RUN export http_proxy=$http_proxy; export https_proxy=$https_proxy; export no_proxy=$no_proxy; /setup.sh; rm -f /setup.sh

WORKDIR /cli

CMD /startup.sh

