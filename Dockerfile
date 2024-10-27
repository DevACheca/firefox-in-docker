FROM alpine:3.18

ARG APPUSERUID=1000
ARG APPGROUPGID=1000

# Install required packages
RUN apk add --no-cache --update py3-cairo
RUN apk add --no-cache --update ttf-dejavu
RUN apk add --no-cache --update firefox-esr

# Copy and prepare the machine ID generation script
COPY generatemachineid.py /root/generatemachineid.py
RUN chmod +x /root/generatemachineid.py
RUN /root/generatemachineid.py > /etc/machine-id && rm /root/generatemachineid.py

# Create a user and group
RUN addgroup --gid $APPGROUPGID appgroup && adduser --disabled-password --uid $APPUSERUID --ingroup appgroup appuser

# Switch to the new user
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

# Run Firefox in xpra
CMD ["run_in_xpra", "firefox"]
