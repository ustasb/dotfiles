bu_source_shell() {
  source ~/.zshrc
}

# Update apps and install dotfiles.
bu_update_system() {
  ~/dotfiles/scripts/update_system.sh
}

# Back up everything at once.
bu_back_up_system() {
  bu_back_up_docs && \
  bu_back_up_photo_booth && \
  bu_back_up_1p && \
  bu_back_up_github_repos
}

# Back up Brian's documents via Git.
bu_back_up_docs() {
  bu_encrypt_journal_entries

  # Reason for subshell: https://stackoverflow.com/a/10382170/1575238
  (cd $USTASB_UNENCRYPTED_DIR_PATH/backups/documents \
    && rsync --archive --delete --exclude='.git/' --exclude='.gitignore' $USTASB_DOCS_DIR_PATH/ ./ \
    && git add . \
    && git status \
    && git commit -m "$(date '+%Y-%m-%d_%H-%M-%S')")
}

# Back up Google Drive contents to S3.
bu_back_up_gdrive() {
  ruby ~/dotfiles/scripts/back_up_gdrive.rb $*
}

# Unravel `bu_back_up_gdrive` archives.
bu_unravel_backup() {
  cat $1 | gpg --decrypt --local-user brianustas@gmail.com | tar -x
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

# Encrypt unencrypted journal entries.
bu_encrypt_journal_entries() {
  for entry in $USTASB_DOCS_DIR_PATH/ustasb/journal/entries/*.md; do
    # Does the file exist?
    # https://stackoverflow.com/a/43606356/1575238
    if [ -e $entry ]; then
      # Don't need to sign when the recipient is myself.
      gpg --encrypt --recipient brianustas@gmail.com $entry && rm $entry
    fi
  done
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

# Test internet connection speed and ping using speedtest.net.
# https://github.com/sindresorhus/speed-test
bu_speed_test() {
  which speed-test &> /dev/null || npm install --global speed-test
  speed-test $*
}

# Outputs the weather forecast with:
# https://github.com/jessfraz/weather
bu_weather() {
  which weather &> /dev/null || brew install darksky-weather
  weather -ignore-alerts -l "Cambridge, MA" $*
}

# Pomodoro timer
# https://github.com/hughbien/thyme
bu_work() {
  which thyme &> /dev/null || echo "Please install Thyme from source (gem is outdated): https://github.com/hughbien/thyme"
  thyme $*
}

# Browse Chrome history with fzf.
# credit: https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf
bu_chrome_hist() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}
