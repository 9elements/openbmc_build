FROM ubuntu:focal
LABEL maintainer="Patrik Tesarik <patrik.tesarik@9elements.com>"

# Personal environment stuff
RUN apt update && \
    apt install -y sudo curl git-core gnupg zsh wget vim locales fonts-powerline && \
    locale-gen en_US.UTF-8 && \
    adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:dev" | chpasswd && \
    usermod -aG sudo devuser

# Dev environment for OpenBMC/Yocto build system
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN apt install -y \
    gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip \
    python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
    libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev

USER devuser
ENV TERM xterm
ENV ZSH_THEME robbyrussell
CMD ["zsh"]
