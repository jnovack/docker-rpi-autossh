FROM alpine:latest

RUN apk update && \
    echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add autossh@testing && \
    rm -rf /var/lib/apt/lists/*

ENV \
    AUTOSSH_LOGFILE=/dev/stdout \
    AUTOSSH_GATETIME=30         \
    AUTOSSH_POLL=10             \
    AUTOSSH_FIRST_POLL=30       \
    AUTOSSH_PORT=13000          \
    # AUTOSSH_DEBUG=1             \
    AUTOSSH_LOGLEVEL=1

ADD /cmd.sh /cmd.sh

RUN chmod 755 /cmd.sh

CMD ["/cmd.sh"]