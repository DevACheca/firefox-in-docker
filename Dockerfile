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
    && mkdir -p /root/.xpra

# Set environment variables for Xpra
ENV XPRA_PORT=10000 \
    XPRA_SERVER=":10000" \
    DISPLAY=":0"

# Start Xpra and Firefox
CMD ["xpra", "start", ":10000", "--start-child=firefox", "--web", "--html=on", "--bind-tcp=0.0.0.0:10000", "--exit-with-children"]
