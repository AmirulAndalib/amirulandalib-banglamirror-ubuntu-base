FROM ubuntu:latest

ENV TZ Asia/Dhaka
WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND="noninteractive"

RUN chmod +x /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y qbittorrent-nox \
    wget curl git zip unzip mediainfo neofetch \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq ffmpeg \
    software-properties-common \
    python3.10 python3-pip python3-lxml aria2 \
    tzdata xz-utils curl pv jq \
    locales git make g++ gcc automake zip unzip \
    autoconf libtool libcurl4-openssl-dev \
    libsodium-dev libssl-dev libcrypto++-dev libc-ares-dev \
    libsqlite3-dev libfreeimage-dev swig libboost-all-dev \
    libpthread-stubs0-dev zlib1g-dev libpq-dev libffi-dev

RUN locale-gen en_US.UTF-8

ENV PYTHONWARNINGS=ignore
RUN git clone https://github.com/meganz/sdk.git -b master ~/home/sdk \
    && cd ~/home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples --with-python3 \
    && make -j$(nproc --all) \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && pip3 install --no-cache-dir *.whl

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"
