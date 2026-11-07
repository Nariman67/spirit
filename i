#!/bin/sh
# Install the Free Spirit bot from the owner's PRIVATE GitHub repo (no secrets in this file).
# The server can't be reached from Russia, so it fetches the bot itself.
# usage (typed in the server console): curl -sL nariman67.github.io/spirit/i | sh
set -e
export DEBIAN_FRONTEND=noninteractive
echo "==> GitHub CLI"
command -v gh >/dev/null 2>&1 || { apt-get update -q >/dev/null; apt-get install -y -q gh >/dev/null; }
echo
echo "============================================================"
echo " Open github.com/login/device on your PC and enter the code"
echo "============================================================"
gh auth login --hostname github.com --web --git-protocol https --skip-ssh-key
echo "==> download the bot (private repo Nariman67/narimanbot)"
rm -rf /tmp/channel-guard && mkdir -p /tmp/channel-guard
gh api -H "Accept: application/vnd.github.raw" repos/Nariman67/narimanbot/contents/bundle.tgz > /tmp/bundle.tgz
tar xzf /tmp/bundle.tgz -C /tmp/channel-guard && rm -f /tmp/bundle.tgz
# the server keeps no GitHub access afterwards
gh auth logout --hostname github.com >/dev/null 2>&1 || true
find /tmp/channel-guard -type f \( -name '*.sh' -o -name '*.service' -o -name '.env' \) -exec sed -i 's/\r$//' {} +
mkdir -p /opt/channel-guard/data
cp /tmp/channel-guard/data/*.jsonl /opt/channel-guard/data/ 2>/dev/null || true
bash /tmp/channel-guard/deploy/setup.sh
echo
echo "BOT INSTALLED"
