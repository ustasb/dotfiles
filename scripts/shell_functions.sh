# Convenient functions for accessing Brian's personal scripts.

# Customize the Finder sidebar defaults.
bu_customize_finder_sidebar() {
  ~/dotfiles/scripts/osx_finder_sidebar/main.sh
}

# Back up Google Drive contents to S3.
bu_back_up_gdrive() {
  ruby ~/dotfiles/scripts/back_up_gdrive.rb $*
}

# Back up Office Snake high scores to Github.
bu_back_up_office_snake_hs() {
  ~/dotfiles/scripts/back_up_office_snake_hs.sh
}

# Back up Photo Booth images to the Cloud.
bu_back_up_photo_booth() {
  ruby ~/dotfiles/scripts/back_up_photo_booth.rb
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

# Test Brian's internet links' behavior.
bu_test_ustasb_internet_links() {
  ruby ~/dotfiles/scripts/test_ustasb_internet_links.rb
}
