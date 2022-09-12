FROM ubuntu:focal
LABEL org.opencontainers.image.authors="patrick.rudolph@9elements.com, arthur.heymans@9elements.com, christian.walter@9elements.com, patrik.tesarik@9elements.com"

ARG USER_ID
ARG GROUP_ID

# Personal environment stuff
RUN apt update
RUN apt install -y sudo curl git-core gnupg zsh wget vim locales fonts-powerline && \
    locale-gen en_US.UTF-8
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    groupadd -g ${GROUP_ID} devuser && \
    adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser --uid ${USER_ID} --gid ${GROUP_ID} && \
    echo "devuser:dev" | chpasswd && \
    usermod -aG sudo devuser; \
    fi

# Dev environment for OpenBMC/Yocto build system
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
RUN apt install -y \
    gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip \
    python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
    libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool

USER devuser
ENV TERM xterm
ENV ZSH_THEME robbyrussell
CMD ["zsh"]
