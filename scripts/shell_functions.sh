# Convenient functions for accessing Brian's personal scripts.

bu_source_shell() {
  source ~/.zshrc
}

# Update apps and install dotfiles.
bu_update_system() {
  ~/dotfiles/scripts/update_system.sh
}

# Back up everything at once.
bu_back_up_system() {
  bu_back_up_notes && \
  bu_back_up_photo_booth && \
  bu_back_up_1p && \
  bu_back_up_github_repos
}

# Back up Brian's notes.
bu_back_up_notes() {
  # Reason for subshell: https://stackoverflow.com/a/10382170/1575238
  (cd $USTASB_NOTES_DIR_PATH/.. \
    && zip --quiet --recurse-paths $USTASB_UNENCRYPTED_DIR_PATH/backups/notes/$(date '+%Y-%m-%d_%H-%M-%S').zip $(basename $USTASB_NOTES_DIR_PATH))
}

# Back up Google Drive contents to S3.
bu_back_up_gdrive() {
  ruby ~/dotfiles/scripts/back_up_gdrive.rb $*
}

# Unravel `bu_back_up_gdrive` archives.
bu_unravel_backup() {
  gzcat $1 | gpg --decrypt --local-user brianustas@gmail.com | tar -x
}

# Back up Office Snake high scores to Github.
bu_back_up_office_snake_hs() {
  ~/dotfiles/scripts/back_up_office_snake_hs.sh
}

# Back up Photo Booth images to the Cloud.
bu_back_up_photo_booth() {
  ruby ~/dotfiles/scripts/back_up_photo_booth.rb
}

# Back up 1Password backups to the Cloud.
bu_back_up_1p() {
  rsync --verbose --checksum --ignore-existing $HOME/Library/Application\ Support/1Password\ 4/Backups/* $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/1password
}

# Back up my source code.
bu_back_up_github_repos() {
  ruby ~/dotfiles/scripts/back_up_github_repos.rb $USTASB_UNENCRYPTED_DIR_PATH/backups/code
}

# Customize the Finder sidebar defaults.
bu_customize_finder_sidebar() {
  ~/dotfiles/scripts/osx_finder_sidebar/main.sh
}

# Build my complete journal.
bu_build_full_journal() {
  ruby ~/dotfiles/scripts/build_full_journal.rb
}

# Create Cryptomator drive symbolic links.
bu_symlink_cryptomator() {
  ruby ~/dotfiles/scripts/create_cryptomator_symlinks.rb
}

# Set the default program for file types.
bu_set_file_type_app_defaults() {
  ~/dotfiles/scripts/set_file_type_app_defaults.sh
}

# See script for details.
bu_tidy_up_pic_names() {
  ruby ~/dotfiles/scripts/tidy_up_image_names.rb $USTASB_UNENCRYPTED_DIR_PATH/pictures
}

# Test Brian's internet links' behavior.
bu_test_ustasb_internet_links() {
  ruby ~/dotfiles/scripts/test_ustasb_internet_links.rb
}

# Print all available terminal colors.
# Credit: http://www.commandlinefu.com/commands/view/5876/show-numerical-values-for-each-of-the-256-colors-in-zsh
bu_term_colors() {
  for code in {000..255}; do print -nP -- "$code: %F{$code}%K{$code}Test%k%f " ; (( code % 8 && code < 255 )) || printf '\n'; done
}

# Show both the public and private IP addresses.
bu_ip_address() {
  public_ip=$(curl -s icanhazip.com)
  echo "public:\n$public_ip"

  if [ `uname -s` == "Darwin" ]; then
    private_ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)
  elif [ `uname -s` == "Linux" ]; then
    private_ip=$(hostname -I)
  fi

  echo "\nprivate:\n$private_ip"
}
