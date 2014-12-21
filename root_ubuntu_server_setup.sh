#!/bin/bash

username="ustasb"

# Update the system
apt-get update
apt-get -y upgrade

# Install programs
apt-get -y install zsh git tmux silversearcher-ag tree
# Ruby dependencies (recommended by sstephenson/ruby-build)
apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the user
# No password - SSH access only
# --gecos "" skips the new user prompt
adduser --disabled-password --gecos "" $username

# Give the user sudo privilege
# Do not require a password (the user has none!)
echo "$username  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
