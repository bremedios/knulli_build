FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y -o APT::Immediate-Configure=0 libc6:i386 \
		libncurses6:i386 \
		libstdc++6:i386 \
		build-essential \
		cmake \
		git \
		libncurses6 \
		libncurses-dev \
		libssl-dev \
		mercurial \
		texinfo \
		zip \
		pigz \
		default-jre \
		imagemagick \
		subversion \
		autoconf \
		automake \
		bison \
		scons \
		libglib2.0-dev \
		bc \
		mtools \
		u-boot-tools \
		flex \
		wget \
		cpio \
		dosfstools \
		libtool \
		rsync \
		device-tree-compiler \
		gettext \
		locales \
		graphviz \
		python3 \
		gcc-multilib \
		g++-multilib \
		make\
    && apt clean \
    && rm -fr /var/lib/apt/lists/


RUN mkdir -p /home/developer
RUN mkdir -p /home/developer/build
RUN mkdir -p /home/developer/toolchains

RUN useradd developer
WORKDIR /home/developer

COPY build.sh .
COPY start.sh .
COPY start_h700.sh .
COPY start_a133.sh .

RUN chown -R developer:developer /home/developer

USER developer
