FROM hypriot/rpi-alpine-scratch:latest
MAINTAINER Justin J. Novack <jnovack@gmail.com>

RUN apk update

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh

# Customization below.

ENV \
    AUTOSSH_LOGFILE=/dev/stdout \
    AUTOSSH_GATETIME=30         \
    AUTOSSH_POLL=10             \
    AUTOSSH_FIRST_POLL=30       \
    AUTOSSH_PORT=13000          \
    AUTOSSH_LOGLEVEL=1

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update autossh@testing && \
    rm -rf /var/lib/apt/lists/*
