#!/bin/bash

[ "$(id -u)" -eq 0 ] && { echo "this script must not be started as root" >&2; exit 1; }

require_sudo() {
  if ! sudo -n true 2>/dev/null; then
    echo "requesting sudo to install packages ..."
    sudo -v || { echo "sudo denied"; exit 1; }
  fi
}

revoke_sudo() {
  sudo -k 2>/dev/null || true
}

echo "executing install tasks as root"

require_sudo

sudo apt-get update
sudo apt-get install --no-install-recommends --no-install-suggests -y \
  ca-certificates \
  curl \
  git \
  jq \
  libicu-dev \
  libxml2-dev

revoke_sudo

echo "executing post-install tasks as $(whoami)"

mkdir "${HOME}/actions-runner" || { echo "could not create directory '${HOME}/actions-runner'"; exit 1; }
cd "${HOME}/actions-runner" || { echo "could not change to directory '${HOME}/actions-runner'"; exit 1; }

curl --proto "=https" --tlsv1.2 -sSf -Lo actions-runner-linux-x64-latest.tar.gz \
  "$(curl --proto "=https" --tlsv1.2 -sSf -L https://api.github.com/repos/actions/runner/releases/latest \
     | jq '.assets[] | select(.name | contains("actions-runner-linux-x64-")).browser_download_url' -r)"

tar vxzf ./actions-runner-linux-x64-latest.tar.gz
rm -f ./actions-runner-linux-x64-latest.tar.gz