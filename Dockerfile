
FROM debian:trixie-slim

RUN apt-get update && apt-get install -y \
    shellinabox \
    openssh-server \
    curl \
    vim \
    && curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb \
    && dpkg -i cloudflared.deb \
    && rm cloudflared.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN echo '#!/bin/sh\n\
if [ -n "$ROOT_PASSWORD" ]; then\n\
  echo "root:$ROOT_PASSWORD" | chpasswd\n\
fi\n\
/usr/sbin/sshd\n\
if [ -n "$TUNNEL_TOKEN" ]; then\n\
  cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &\n\
fi\n\
exec shellinaboxd -t -p 10000 --no-beep --disable-peer-check -s /:LOGIN' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

EXPOSE 10000 22

ENTRYPOINT ["/entrypoint.sh"]


ENTRYPOINT ["/entrypoint.sh"]
