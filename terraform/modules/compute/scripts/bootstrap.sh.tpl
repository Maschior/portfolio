#!/bin/bash
apt-get update -y
apt-get install -y curl git nginx

# installing cloudflared to setup Tunnel
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# cloudflare repo
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared noble main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# installing cloudflare
sudo apt-get update && sudo apt-get install cloudflared

cloudflared service install ${tunnel_token}

systemctl enable cloudflared
systemctl start cloudflared

systemctl enable nginx
systemctl start nginx