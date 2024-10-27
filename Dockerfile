# Use Alpine Linux as the base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache \
    firefox \
    xpra \
    xorg-server \
    xf86-video-dummy \
    dbus \
    ttf-freefont \
    bash \
    && mkdir -p /root/.xpra \
    && adduser -D xprauser \
    && mkdir -p /tmp/xpra-user && chown xprauser:xprauser /tmp/xpra-user

# Switch to the non-root user
USER xprauser

# Set environment variables for Xpra
ENV XPRA_PORT=10000 \
    XPRA_SERVER=":10000" \
    DISPLAY=":0" \
    XDG_RUNTIME_DIR="/tmp/xpra-user"

# Create a start script to run Xpra and log output
RUN echo '#!/bin/sh\nexec xpra start :10000 --start-child=firefox --web --html=on --bind-tcp=0.0.0.0:10000 --exit-with-children' > /start-xpra.sh && \
    chmod +x /start-xpra.sh

# Set the entrypoint to the start script
ENTRYPOINT ["/start-xpra.sh"]
