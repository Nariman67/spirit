#!/bin/sh
# one-time: let Nariman's PC in by SSH key (public key only — safe to publish)
mkdir -p /root/.ssh
grep -q nariman-bot-server /root/.ssh/authorized_keys 2>/dev/null || echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeRb5R8gErvxqxb00kCQno654Z7CeNjAp/HEhIZCva8 nariman-bot-server" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys
systemctl enable --now ssh >/dev/null 2>&1
echo "--- ssh:"; ss -tlnp | grep ':22 '
echo "--- firewall:"; ufw status 2>/dev/null; iptables -S INPUT 2>/dev/null | head -5
echo "KEY OK"