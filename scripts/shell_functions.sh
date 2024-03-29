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
  bu_create_small_s3_backup
}

# Back up a small, important subset to S3.
# (Really don't fully trust Cryptomator yet. :D)
bu_create_small_s3_backup() {
  backup_dir=$HOME/backups
  backup_folder="backup-$(date '+%Y-%m-%d_%H-%M-%S_%Z')"
  backup_path="$backup_dir/$backup_folder"

  mkdir -p $backup_path

  # back up docs
  cp $USTASB_UNENCRYPTED_DIR_PATH/backups/notes.zip $backup_path

  # back up 1p (most recent backup)
  (cd $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/1password && \
   cp "$(ls -t | head -1)" $backup_path)

  # create S3 archive
  (cd $backup_dir && \
    zip -r --quiet "$backup_folder.zip" $backup_folder && \
    gpg --symmetric "$backup_folder.zip" && \
    cp "$backup_folder.zip.gpg" "$USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/small_s3_backup.zip.gpg" && \
    AWS_ACCESS_KEY_ID=$USTASB_AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$USTASB_AWS_SECRET_ACCESS_KEY AWS_REGION=$USTASB_AWS_REGION \
    aws s3 cp "$backup_folder.zip.gpg" "s3://$USTASB_S3_BACKUP_BUCKET_NAME/small-backups/")

  # clean up
  rm -rf $backup_path "$backup_path.zip"
}

bu_back_up_notes() {
  # Updates the archive in-place.
  (cd "$(dirname $USTASB_DOCS_DIR_PATH)" && \
    zip --filesync --recurse-paths $USTASB_UNENCRYPTED_DIR_PATH/backups/notes.zip $(basename $USTASB_DOCS_DIR_PATH))
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

bu_back_up_1p() {
  # Back up the latest three 1Password backups.
  if ls $HOME/Library/Group\ Containers/*.com.agilebits/Library/Application\ Support/1Password/Backups 1> /dev/null 2>&1; then
    (rm -rf $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/1password/* \
      && cd $HOME/Library/Group\ Containers/*.com.agilebits/Library/Application\ Support/1Password/Backups \
      && ls -t | head -3 | xargs -I{} cp {} $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/1password)
  else
    echo "1Password backup folder not found!"
  fi
}

# Customize the Finder sidebar defaults.
bu_customize_finder_sidebar() {
  # pip install finder-sidebar-editor
  python ~/dotfiles/scripts/customize_finder_sidebar.py
}

# Set the default program for file types.
bu_set_file_type_app_defaults() {
  ~/dotfiles/scripts/set_file_type_app_defaults.sh
}

# Test Brian's internet links' behavior.
bu_test_ustasb_internet_links() {
  ruby ~/dotfiles/scripts/test_ustasb_internet_links.rb
}

# Print all available terminal colors.
# Credit: http://www.commandlinefu.com/commands/view/5876/show-numerical-values-for-each-of-the-256-colors-in-zsh
bu_term_colors() {
  for code in {000..255}; do print -nP -- "$code: %F{$code}%K{$code}Test%k%f " ; (( ((code + 1) % 8) && code < 255 )) || printf '\n'; done
}

# Show both the public and private IP addresses.
bu_ip_address() {
  public_ip=$(curl -s icanhazip.com)
  echo "public:\n$public_ip"

  if [ `uname -s` == "Darwin" ]; then
    local_ip=$(bu_local_ip_address)
  elif [ `uname -s` == "Linux" ]; then
    local_ip=$(hostname -I)
  fi

  echo "\nlocal:\n$local_ip"
}

# Browse Chrome history with fzf.
# credit: https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf
bu_chrome_hist() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History $TMPDIR/chrome_history

  sqlite3 -separator $sep $TMPDIR/chrome_history \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

# List the active Chrome window's tabs' links.
bu_chrome_tabs_links() {
  ruby ~/dotfiles/scripts/chrome_tabs_links.rb
}

# Render Markdown files as HTML.
bu_markdown_to_html() {
  ruby ~/dotfiles/pandoc/markdown_to_html.rb $*
}

# reveal.js presentations with Markdown.
# shortcuts: (s)peaker notes, (f)ullscreen, (o)utline
bu_slideshow() {
  which reveal-md &> /dev/null || npm install --global reveal-md
  (cd $USTASB_DOCS_DIR_PATH && \
   reveal-md --theme white $(find . -name '*.md' | fzf --height 30%))
}

# Open ebooks with fzf.
bu_ebooks() {
  (cd $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/ebooks && \
    open "$(find . -name '*.pdf' | fzf --height 30%)")
}

# Displays all blob objects in the repository, sorted from smallest to largest.
# credit: https://stackoverflow.com/a/42544963/1575238
bu_list_git_blobs() {
  git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
  | sed -n 's/^blob //p' \
  | sort --numeric-sort --key=2 \
  | cut -c 1-12,41- \
  | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

# Scrape Eventbrite for events that match keywords.
bu_eventbrite_events() {
  ruby ~/dotfiles/scripts/eventbrite_scraper.rb $*
}
