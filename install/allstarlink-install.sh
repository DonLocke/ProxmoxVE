#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: Don Locke (DonLocke)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/AllStarLink

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Adding ASL Package Repository"
wget -q -P /tmp https://repo.allstarlink.org/public/asl-apt-repos.deb12_all.deb
dpkg -i /tmp/asl-apt-repos.deb12_all.deb
$STD apt-get update
msg_ok "Added ASL Package Repository"

msg_info "Installing AllStarLink"
$STD apt-get install -y asl3
msg_ok "Installed AllStarLink"

read -r -p "Would you like to add Allmon3? <y/N> " prompt
if [[ ${prompt,,} =~ ^(y|yes)$ ]]; then
  msg_info "Installing Allmon3"
  $STD apt-get install -y allmon3
  msg_ok "Installed Allmon3"
fi

motd_ssh
customize

msg_info "Cleaning up"
rm -f /tmp/asl-apt-repos.deb12_all.deb
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
