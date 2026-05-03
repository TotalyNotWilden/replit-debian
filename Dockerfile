FROM debian:trixie-slim
RUN apt-get update && apt-get install -y \
    shellinabox \
    curl \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
RUN echo '#!/bin/sh\n\
if [ -n "$ROOT_PASSWORD" ]; then\n\
  echo "root:$ROOT_PASSWORD" | chpasswd\n\
fi\n\
exec shellinaboxd -t -p 10000 --disable-peer-check -s /:LOGIN' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]
