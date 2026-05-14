#!/bin/bash
set -euo pipefail

# --- Pacotes base ---
apt-get update -y
apt-get install -y curl git nginx

# --- Instalação do cloudflared ---
mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared noble main' \
  | tee /etc/apt/sources.list.d/cloudflared.list

apt-get update -y
apt-get install -y cloudflared

# --- Configuração do Cloudflare Tunnel ---
cloudflared service install ${tunnel_token}

# --- Habilitar e iniciar serviços ---
systemctl enable --now cloudflared
systemctl enable --now nginx