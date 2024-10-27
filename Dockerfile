FROM debian:bookworm

# Make sure apt doesn't sit and wait for input
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and dependencies for building Xpra
RUN \
    apt-get update && \
    apt-get install -y \
        git \
        pkg-config \                  # Added pkg-config
        python3-pip \
        python3-setuptools \
        python3-dev \
        libjpeg-dev \                 # Add necessary libraries
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libx264-dev \
        libx11-dev \
        libxext-dev \
        libxi-dev \
        libxrender-dev \
        libxrandr-dev \
        libgtk-3-dev \
        libpulse-dev \
        libqt5svg5-dev \
        python3-uinput \
        python3-netifaces \
        python3-pyinotify \
        ffmpeg \
        vlc \
        curl && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Clone and install the latest version of Xpra
RUN \
    git clone https://github.com/Xpra-org/xpra /opt/xpra && \
    cd /opt/xpra && \
    python3 setup.py install-repo && \
    pip3 install xpra

# Setup a non-root user
ARG NON_ROOT_USERNAME=container
ARG NON_ROOT_UID=1000
ARG NON_ROOT_GID=1000

RUN \
    groupadd --gid $NON_ROOT_GID $NON_ROOT_USERNAME && \
    useradd --uid $NON_ROOT_UID --gid $NON_ROOT_GID -m $NON_ROOT_USERNAME

USER $NON_ROOT_USERNAME

EXPOSE 10000

ENTRYPOINT ["xpra", "start", "--daemon=no", "--start=firefox", "--bind-tcp=0.0.0.0:10000"]
