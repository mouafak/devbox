FROM ubuntu:24.04

# Ubuntu 24.04 contient déjà un utilisateur « ubuntu » en UID 1000 : on le remplace
RUN userdel -r ubuntu || true

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git zsh tmux jq unzip less vim openssh-client gosu \
 && rm -rf /var/lib/apt/lists/*

# Moteur Docker interne (ne fonctionne qu'avec le runtime Sysbox)
RUN curl -fsSL https://get.docker.com | sh
# Docker 29 utilise par défaut le stockage containerd, qui pose des problèmes
# connus dans Sysbox : on garde l'ancien stockage overlay2 pour le Docker interne
RUN mkdir -p /etc/docker \
 && echo '{"features":{"containerd-snapshotter":false}}' > /etc/docker/daemon.json

# Node LTS + CLI Dev Containers
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
 && apt-get install -y nodejs && npm install -g @devcontainers/cli

# code-server (VS Code dans le navigateur)
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN useradd -m -u 1000 -s /bin/zsh dev && usermod -aG docker dev

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]