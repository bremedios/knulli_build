FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y -o APT::Immediate-Configure=0 libc6:i386 \
        git\
    && apt clean \
    && rm -fr /var/lib/apt/lists/


RUN mkdir -p /home/developer
RUN useradd developer
RUN chown developer:developer /home/developer
WORKDIR /home/developer

USER developer

RUN git clone https://github.com/knulli-cfw/distribution.git

CMD ["/usr/bin/bash"]

