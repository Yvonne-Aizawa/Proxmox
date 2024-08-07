#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y gpg
$STD apt-get install -y apt-transport-https
msg_ok "Installed Dependencies"

msg_info "Installing authelia"
mkdir -p /etc/apt/keyrings
curl https://apt.authelia.com/organization/signing.asc | sudo apt-key add -
echo "deb https://apt.authelia.com/stable/debian/debian/ all main" | sudo tee /etc/apt/sources.list.d/authelia-stable-debian.list 
$STD apt-get update
$STD apt-get install -y authelia
systemctl enable -q --now authelia
msg_ok "Installed authelia"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
