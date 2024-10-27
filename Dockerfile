FROM debian:bookworm

# Make sure apt doesn't sit and wait for input
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y firefox-esr libpci3 python3 python3-uinput python3-netifaces python3-pyinotify ffmpeg vlc curl git && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Clone the xpra-html5 repository and install it
RUN mkdir /tmp/xpra && \
    cd /tmp/xpra && \
    git clone https://github.com/Xpra-org/xpra && \
    cd xpra && \
    python3 setup.py install-repo && \
    cd / && \
    rm -rf /tmp/xpra

# Setup a non-root user
ARG NON_ROOT_USERNAME=container
ARG NON_ROOT_UID=1000
ARG NON_ROOT_GID=1000

RUN groupadd --gid $NON_ROOT_GID $NON_ROOT_USERNAME && \
    useradd --uid $NON_ROOT_UID --gid $NON_ROOT_GID -m $NON_ROOT_USERNAME

USER $NON_ROOT_USERNAME

EXPOSE 10000

ENTRYPOINT ["xpra", "start", "--daemon=no", "--start=firefox", "--bind-tcp=0.0.0.0:10000"]
