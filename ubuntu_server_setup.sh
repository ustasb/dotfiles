#!/bin/bash

# Exit if any errors are encountered
set -e

username="ustasb"

curl https://raw.githubusercontent.com/ustasb/dotfiles/master/root_ubuntu_server_setup.sh | bash

su - $username -c "$(curl https://raw.githubusercontent.com/ustasb/dotfiles/master/user_ubuntu_server_setup.sh)"
