#!/bin/sh

if [ -f /id_rsa ]; then
  echo "[INFO] /id_rsa found..."
  echo -n "[INFO] " && ssh-keygen -E md5 -lf /id_rsa
else
  echo "[WARN] /id_rsa NOT found.  Generating..."
  ssh-keygen -f id_rsa -t rsa -N ''
  cat /id_rsa.pub
fi

chmod 0400 /id_rsa

# Pick a random port above 32768
DEFAULT_PORT=$RANDOM
let "DEFAULT_PORT += 32768"
echo [INFO] Tunneling ${SSH_USER:=root}@${SSH_HOST:=localhost}:${SSH_REMOTE:=${DEFAULT_PORT}} to 127.0.0.1:${SSH_LOCAL:=22}

echo autossh \
 -M 0 \
 -g \
 -N \
 -o StrictHostKeyChecking=no \
 -o ServerAliveInterval=5 \
 -o ServerAliveCountMax=1 \
 -i /id_rsa \
 -R ${SSH_REMOTE}:127.0.0.1:${SSH_LOCAL} \
 -p ${SSH_PORT:=22} \
 ${SSH_USER}@${SSH_HOST}

autossh \
 -M 0 \
 -g \
 -N \
 -o StrictHostKeyChecking=no \
 -o ServerAliveInterval=5 \
 -o ServerAliveCountMax=1 \
 -i /id_rsa \
 -R ${SSH_REMOTE}:127.0.0.1:${SSH_LOCAL} \
 -p ${SSH_PORT:=22} \
 ${SSH_USER}@${SSH_HOST}
