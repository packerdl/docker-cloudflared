FROM resin/rpi-raspbian

RUN curl https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz | tar xzC /usr/local/bin

ENTRYPOINT ["cloudflared"]
