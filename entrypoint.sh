#!/bin/sh
set -e
# Démarre le Docker interne
dockerd > /var/log/dockerd.log 2>&1 &
for i in $(seq 1 30); do docker info >/dev/null 2>&1 && break; sleep 1; done
# Lance code-server en tant qu'utilisateur dev
exec gosu dev code-server --bind-addr 0.0.0.0:8080 --auth password /home/dev