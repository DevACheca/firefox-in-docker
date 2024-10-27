# Use the latest version of Alpine Linux as the base image
FROM alpine:3.17

# Install necessary packages and link bash for compatibility
RUN apk add --no-cache \
    bash \
    git \
    py3-cairo \
    py3-xdg \
    su-exec \
    xhost \
    xpra \
    firefox

# Clone the xpra-html5 repository and install it
RUN mkdir /tmp/xpra-html5 && \
    cd /tmp/xpra-html5 && \
    git clone https://github.com/Xpra-org/xpra-html5 && \
    cd xpra-html5 && \
    ./setup.py install && \
    cd / && \
    rm -rf /tmp/xpra-html5

# Define volumes for X11 socket
VOLUME /tmp/.X11-unix

# Copy custom binaries from the local bin directory to the container
# COPY bin/* /usr/local/bin/

# Set environment variables for Xpra and general configuration
ENV DISPLAY=":14"            \
    SHELL="/usr/bin/bash"    \
    START_XORG="yes"         \
    XPRA_HTML="no"           \
    XPRA_MODE="start"        \
    XPRA_READONLY="no"       \
    XORG_DPI="96"            \
    XPRA_COMPRESS="0"        \
    XPRA_DPI="0"             \
    XPRA_ENCODING="rgb"      \
    XPRA_HTML_DPI="96"       \
    XPRA_KEYBOARD_SYNC="yes" \
    XPRA_MMAP="yes"          \
    XPRA_SHARING="yes"       \
    XPRA_TCP_PORT="10000"    \
    XPRA_WS_PORT="10001"

# User configuration
ENV GID="1000"         \
    GNAME="xpra"       \
    UHOME="/home/xpra" \
    UID="1000"         \
    UNAME="xpra"

# Expose only the necessary ports for Xpra
EXPOSE $XPRA_TCP_PORT $XPRA_WS_PORT

# Set the entry point and default command for the container
# ENTRYPOINT ["/usr/local/bin/run"]

# Start Firefox along with xhost command
CMD ["sh", "-c", "xhost + && firefox"]
