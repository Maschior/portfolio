#!/bin/bash
set -euo pipefail

# --- Pacotes base ---
apt-get update -y
apt-get install -y curl git nginx ansible

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

cat << 'EOF' > /tmp/ansible/ansible.cfg
[defaults]
inventory = hosts
host_key_checking = False
stdout_callback = yaml
connection = local
EOF

cat << 'EOF' > /tmp/ansible/hosts
[localhost]
127.0.0.1 ansible_connection=local
EOF

cat << 'EOF' > /tmp/ansible/playbook.yml
---
- name: Provision Portfolio Server
  hosts: localhost
  become: true
  tasks:
    - name: Ensure Nginx is installed
      apt:
        name: nginx
        state: present

    - name: Create portfolio web directory
      file:
        path: /var/www/portfolio
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Create a beautiful placeholder portfolio page
      copy:
        dest: /var/www/portfolio/index.html
        owner: www-data
        group: www-data
        mode: '0644'
        content: |
          <!DOCTYPE html>
          <html lang="pt-BR">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Portfolio - Em Construção</title>
              <style>
                  body {
                      font-family: 'Outfit', 'Inter', sans-serif;
                      background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
                      color: #f8fafc;
                      height: 100vh;
                      margin: 0;
                      display: flex;
                      align-items: center;
                      justify-content: center;
                      text-align: center;
                  }
                  .container {
                      background: rgba(255, 255, 255, 0.05);
                      backdrop-filter: blur(10px);
                      padding: 3rem;
                      border-radius: 16px;
                      border: 1px solid rgba(255, 255, 255, 0.1);
                      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
                      max-width: 500px;
                  }
                  h1 {
                      font-size: 2.5rem;
                      margin-bottom: 1rem;
                      background: linear-gradient(to right, #38bdf8, #818cf8);
                      -webkit-background-clip: text;
                      -webkit-text-fill-color: transparent;
                  }
                  p {
                      font-size: 1.1rem;
                      color: #94a3b8;
                      line-height: 1.6;
                  }
                  .status {
                      display: inline-block;
                      margin-top: 1.5rem;
                      padding: 0.5rem 1rem;
                      background: rgba(56, 189, 248, 0.15);
                      color: #38bdf8;
                      border-radius: 9999px;
                      font-weight: 600;
                      font-size: 0.9rem;
                      border: 1px solid rgba(56, 189, 248, 0.3);
                  }
              </style>
          </head>
          <body>
              <div class="container">
                  <h1>Portfolio Maschior</h1>
                  <p>A infraestrutura AWS foi provisionada com sucesso via Terraform, integrada ao Cloudflare Tunnel e automatizada com GitHub Actions & Ansible.</p>
                  <div class="status">Status: Pronto para implantação da aplicação</div>
              </div>
          </body>
          </html>

    - name: Configure Nginx default site block
      copy:
        dest: /etc/nginx/sites-available/default
        owner: root
        group: root
        mode: '0644'
        content: |
          server {
              listen 80 default_server;
              listen [::]:80 default_server;

              root /var/www/portfolio;
              index index.html;

              server_name _;

              location / {
                  try_files $uri $uri/ =404;
              }
          }
      notify: Restart Nginx

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
        enabled: true
EOF

# Rodar Ansible Playbook
cd /tmp/ansible
ansible-playbook playbook.yml