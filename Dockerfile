FROM alpine:3.18

# Install necessary packages
RUN apk add --no-cache --update xpra py3-paramiko py3-cairo ttf-dejavu firefox-esr

# Set up Xpra configuration
RUN cp /etc/xpra/xorg.conf /etc/X11/xorg.conf.d/00_xpra.conf
RUN echo "xvfb=Xorg" >> /etc/xpra/xpra.conf

# Set environment variables
ENV XPRA_DISPLAY=":100"
ARG XPRA_PORT=10000
ENV XPRA_PORT=$XPRA_PORT
EXPOSE $XPRA_PORT

# Create user and group first
ARG APPUSERUID=1000
ARG APPGROUPGID=1000
RUN addgroup --gid $APPGROUPGID appgroup && adduser --disabled-password --uid $APPUSERUID --ingroup appgroup appuser

# Create required directories after user and group are created
RUN mkdir -p /run/user/1000/xpra && chown -R appuser:appgroup /run/user/1000
ENV XDG_RUNTIME_DIR=/run/user/1000

# Copy the run_in_xpra script to the appropriate directory
COPY run_in_xpra /usr/bin/run_in_xpra
RUN chmod +x /usr/bin/run_in_xpra

# Copy and prepare the machine ID generation script
COPY generatemachineid.py /root/generatemachineid.py
RUN chmod +x /root/generatemachineid.py
RUN /root/generatemachineid.py > /etc/machine-id && rm /root/generatemachineid.py

# Switch to the new user for non-Xpra commands
USER appuser
WORKDIR /home/appuser

# Set up Firefox profile
RUN mkdir -p .mozilla/firefox/abcdefgh.default
RUN echo 'user_pref("browser.tabs.remote.autostart", false);' > .mozilla/firefox/abcdefgh.default/user.js
RUN echo '[General]\n\
StartWithLastProfile=1\n\
\n\
[Profile0]\n\
Name=Default User\n\
IsRelative=1\n\
Path=abcdefgh.default\n\
' > .mozilla/firefox/profiles.ini

# Switch back to root for Xpra command
USER root

# Run Firefox in xpra
CMD ["/usr/bin/run_in_xpra", "firefox"]
