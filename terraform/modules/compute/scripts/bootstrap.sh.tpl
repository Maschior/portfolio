#!/bin/bash
set -euo pipefail

# --- Pacotes base ---
apt-get update -y
apt-get install -y curl git nginx ansible unzip

# --- Instalação do AWS CLI v2 ---
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
rm -rf /tmp/awscliv2.zip /tmp/aws

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

# --- Habilitar e iniciar serviços base ---
systemctl enable --now cloudflared

# --- Configurar e Rodar o Ansible localmente ---
mkdir -p /tmp/ansible

cat << 'EOF_ANSIBLE_CONFIG' > /tmp/ansible/ansible.cfg
${ansible_config}
EOF_ANSIBLE_CONFIG

cat << 'EOF_ANSIBLE_HOSTS' > /tmp/ansible/hosts
${ansible_hosts}
EOF_ANSIBLE_HOSTS

cat << 'EOF_ANSIBLE_PLAYBOOK' > /tmp/ansible/playbook.yml
${ansible_playbook}
EOF_ANSIBLE_PLAYBOOK

# Rodar Ansible Playbook
cd /tmp/ansible
ansible-playbook playbook.yml