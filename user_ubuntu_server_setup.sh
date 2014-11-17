#!/bin/bash

ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDULY4HUA3rOoi3btSe3JtjlnOdec8hVB0adgFwcFp5sJJCdyVxCw5C5ec9UMSU88SPECncRLQLBDS9cz0kIaJcrWJfCBbZsLYLpC3kQ3LiuXAOngDwX5mbO41AzNq3pTeYC5Ou7fbYaXimszOkSFd+N9owEcDkcgg+l23vGfbR5wYZ+jvkjcoSQ1RTi1GjQ2JaepJGo8a36PBt8TDw85Gvarhgqkdwgp/4jjfsfYE0HP3tGXhIkQXa7fjzrmauWxtWIqnLJfqb/aPHJJcpyCCWIu6CHnKyvL3zwwN0K5I+90OEcGf7EJNW9FvCMJh3kt9jDHM6ovD+BhqF8MLaEtr brianustas@gmail.com"
ruby_version="2.1.5"
node_version="v0.10.33"

# Clean the home directory
rm -vr ~/\.* 2> /dev/null

# Make the ~/.ssh folder
mkdir ~/.ssh
chmod 700 ~/.ssh

# Add the SSH key to the server
echo $ssh_key >> ~/.ssh/authorized_keys

# Install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
# Install ruby-build (used to install Ruby versions)
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
# Initialize rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
# Install a Ruby version
rbenv install $ruby_version
rbenv global $ruby_version

# Install dotfiles
git clone https://github.com/ustasb/dotfiles.git ~/dotfiles
cd ~/dotfiles
rake update_sys

# Install NVM
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
source ~/.nvm/nvm.sh
# Install a Node.js version
nvm install $node_version
nvm use $node_version

# Make zsh the default shell
sudo chsh -s $(which zsh) $(whoami)

