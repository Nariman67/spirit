#!/bin/sh
# Turn on the REDLINE casino on the server (bot already installed). No secrets in this file.
# usage (typed in the server console): curl -sL nariman67.github.io/spirit/c | sh
set -e
export DEBIAN_FRONTEND=noninteractive
command -v gh >/dev/null 2>&1 || { apt-get update -q >/dev/null; apt-get install -y -q gh >/dev/null; }
echo
echo "============================================================"
echo " Open github.com/login/device on your PC and enter the code"
echo "============================================================"
gh auth login --hostname github.com --web --git-protocol https
echo "==> download the latest code (private repo Nariman67/narimanbot)"
rm -rf /tmp/channel-guard && mkdir -p /tmp/channel-guard
gh api -H "Accept: application/vnd.github.raw" repos/Nariman67/narimanbot/contents/bundle.tgz > /tmp/bundle.tgz
tar xzf /tmp/bundle.tgz -C /tmp/channel-guard && rm -f /tmp/bundle.tgz
gh auth logout --hostname github.com >/dev/null 2>&1 || true
find /tmp/channel-guard -type f \( -name '*.sh' -o -name '*.service' \) -exec sed -i 's/\r$//' {} +
# code only: data/ and .env on the server stay as they are
D=/opt/channel-guard
rm -rf "$D/casino"
cp -r /tmp/channel-guard/bot.py /tmp/channel-guard/guard /tmp/channel-guard/casino /tmp/channel-guard/requirements.txt /tmp/channel-guard/deploy "$D/"
"$D/.venv/bin/pip" install -q --disable-pip-version-check -r "$D/requirements.txt"
rm -rf /tmp/channel-guard
bash "$D/deploy/casino_setup.sh"
echo
echo "CASINO INSTALLED"
