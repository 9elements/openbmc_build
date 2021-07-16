FROM ubuntu:bionic
LABEL maintainer="Arthur Heymans <arthur.heymans@9elements.com>"

RUN apt-get update
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/devuser --gecos "User" devuser && \
    echo "devuser:dev" | chpasswd && \
    usermod -aG sudo devuser


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Brussels
RUN apt-get install -y \
	gawk wget git-core git diffstat unzip texinfo gcc-multilib build-essential \
	chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils \
	debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
	libsdl1.2-dev pylint3 xterm sed cvs subversion help2man make gcc \
	g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial \
	autoconf automake groff curl lzop asciidoc

USER devuser
CMD ["bash"]
