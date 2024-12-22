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
    
# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ=Europe/Paris

# Workaround host-tar configure error
ENV FORCE_UNSAFE_CONFIGURE=1

RUN mkdir -p /home/developer
RUN mkdir -p /home/developer/build
RUN mkdir -p /home/developer/toolchains
RUN mkdir -p /home/developer/.buildroot-ccache

RUN useradd developer
WORKDIR /home/developer

COPY build.sh .
COPY start.sh .
COPY start_a133.sh .
COPY start_atm7039.sh .
COPY start_h700.sh .
COPY start_r16.sh .
COPY start_rk3128.sh .
COPY start_rk3566.sh .
COPY start_rk3568.sh .
COPY start_sm8250.sh .

RUN chown -R developer:developer /home/developer

USER developer
