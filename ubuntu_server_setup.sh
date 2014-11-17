#!/bin/bash

# Exit if any errors are encountered
set -e

username="ustasb"

curl -O https://raw.githubusercontent.com/ustasb/dotfiles/master/root_ubuntu_server_setup.sh
curl -O https://raw.githubusercontent.com/ustasb/dotfiles/master/user_ubuntu_server_setup.sh

bash root_ubuntu_server_setup.sh

su - $username -c "$(cat user_ubuntu_server_setup.sh)"

rm root_ubuntu_server_setup.sh
rm user_ubuntu_server_setup.sh
