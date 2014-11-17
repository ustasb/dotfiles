#!/bin/bash

# Stop execution if something fails
set -e

username="ustasb"
ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDULY4HUA3rOoi3btSe3JtjlnOdec8hVB0adgFwcFp5sJJCdyVxCw5C5ec9UMSU88SPECncRLQLBDS9cz0kIaJcrWJfCBbZsLYLpC3kQ3LiuXAOngDwX5mbO41AzNq3pTeYC5Ou7fbYaXimszOkSFd+N9owEcDkcgg+l23vGfbR5wYZ+jvkjcoSQ1RTi1GjQ2JaepJGo8a36PBt8TDw85Gvarhgqkdwgp/4jjfsfYE0HP3tGXhIkQXa7fjzrmauWxtWIqnLJfqb/aPHJJcpyCCWIu6CHnKyvL3zwwN0K5I+90OEcGf7EJNW9FvCMJh3kt9jDHM6ovD+BhqF8MLaEtr brianustas@gmail.com"
ruby_version="2.1.5"
node_version="v0.10.33"

# Update the system
apt-get update
apt-get -y upgrade

# Install programs
apt-get -y install build-essential zsh git

# Create the user
# No password - SSH access only
# --gecos "" skips the new user prompt
adduser --disabled-password --gecos "" $username

# Give the user sudo privilege
# Do not require a password (the user has none)
echo "$username  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Log in as the user
# The - creates a new environment with the user's settings
su - $username <<'EOF'

  echo $(whoami)

  # Clean the home directory
  rm -vr \.*

  # Make the ~/.ssh folder
  cd ~
  mkdir .ssh
  chmod 700 .ssh

  # Add the SSH key to the server
  echo $ssh_key >> .ssh/authorized_keys

  # Install rbenv
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  # Install ruby-build (used to install Ruby versions)
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  # Install a Ruby version
  rbenv install $ruby_version
  rbenv global $ruby_version

  # Install dotfiles
  git clone https://github.com/ustasb/dotfiles.git
  cd dotfiles
  rake update_sys
  cd ~

  # Install NVM
  curl https://raw.githubusercontent.com/creationix/nvm/v0.18.0/install.sh | bash
  source ~/.nvm/nvm.sh
  # Install a Node.js version
  nvm install $node_version
  nvm use $node_version

  # Make zsh the default shell
  sudo chsh -s $(which zsh) $(whoami)

EOF
