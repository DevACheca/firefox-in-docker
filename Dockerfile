FROM debian:bookworm

# make sure apt doesn't sit and wait for input
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y firefox-esr xpra libpci3 python3 python3-uinput python3-netifaces python3-pyinotify ffmpeg vlc curl && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Clone the xpra-html5 repository and install it
RUN mkdir /tmp/xpra-html5 && \
    cd /tmp/xpra-html5 && \
    git clone https://github.com/Xpra-org/xpra-html5 && \
    cd xpra-html5 && \
    ./setup.py install && \
    cd / && \
    rm -rf /tmp/xpra-html5


# setup a non-root-user
ARG NON_ROOT_USERNAME=container
ARG NON_ROOT_UID=1000
ARG NON_ROOT_GID=1000

RUN \
    groupadd --gid $NON_ROOT_GID $NON_ROOT_USERNAME && \
    useradd --uid $NON_ROOT_UID --gid $NON_ROOT_GID -m $NON_ROOT_USERNAME

USER $NON_ROOT_USERNAME

EXPOSE 10000

ENTRYPOINT ["xpra", "start", "--daemon=no", "--start=firefox", "--bind-tcp=0.0.0.0:10000"]
