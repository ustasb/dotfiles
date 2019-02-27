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
  cp -r $USTASB_UNENCRYPTED_DIR_PATH/backups/documents.zip $backup_path

  # back up 1p (most recent backup)
  (cd $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/1password && \
   cp "$(ls -t | head -1)" $backup_path)

  # create S3 archive
  (cd $backup_dir && \
    zip -r --quiet "$backup_folder.zip" $backup_folder && \
    gpg --symmetric --no-armor "$backup_folder.zip" && \
    AWS_ACCESS_KEY_ID=$USTASB_AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$USTASB_AWS_SECRET_ACCESS_KEY AWS_REGION=$USTASB_AWS_REGION \
    aws s3 cp "$backup_folder.zip.gpg" "s3://$USTASB_S3_BACKUP_BUCKET_NAME/small-backups/")

  # clean up
  rm -rf $backup_path "$backup_path.zip"
}

# Back up Brian's documents via Git.
bu_back_up_docs() {
  bu_encrypt_journal
  # Updates the archive in-place.
  (cd $USTASB_UNENCRYPTED_DIR_PATH && zip --recurse-paths --filesync backups/documents.zip documents)
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

# Back up my source code.
# FIXME: Back up into gzip archives.
bu_back_up_github_repos() {
  # ruby ~/dotfiles/scripts/back_up_github_repos.rb $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/backups/code
  echo "see FIXME"
}

# Customize the Finder sidebar defaults.
bu_customize_finder_sidebar() {
  ~/dotfiles/scripts/osx_finder_sidebar/main.sh
}

# Build my complete journal.
bu_build_full_journal() {
  bu_encrypt_journal
  ruby ~/dotfiles/scripts/build_full_journal.rb
}

# Encrypt unencrypted journal entries.
bu_encrypt_journal() {
  for entry in $USTASB_DOCS_DIR_PATH/ustasb/journal/{entries/*.md,voice_memos/*.ogg,voice_memos/*.m4a}; do
    # Does the file exist?
    # https://stackoverflow.com/a/43606356/1575238
    if [ -e $entry ]; then
      # Don't need to sign when the recipient is myself.
      gpg --encrypt --recipient brianustas@gmail.com $entry && rm $entry
    fi
  done
}

# Scans all Markdown documents and localizes images.
bu_localize_doc_images() {
  ruby ~/dotfiles/scripts/localize_markdown_images.rb $*
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
  weather -ignore-alerts -l "Cambridge, MA" -d 3 $* | less -r
}

# Browse Chrome history with fzf.
# credit: https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf
bu_chrome_hist() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/chrome_history

  sqlite3 -separator $sep /tmp/chrome_history \
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
  (cd $USTASB_DOCS_DIR_PATH/talks/slides && \
   reveal-md --theme white $(find . -name '*.md' | fzf --height 30%))
}

# Open ebooks with fzf.
bu_ebooks() {
  (cd $USTASB_CLOUD_DIR_PATH/ustasb_not_encrypted/ebooks && \
    open "$(find . -name '*.pdf' | fzf --height 30%)")
}

# Records a voice memo with `sox`.
# `bu_voice_memo <optional-title>`
# http://sox.sourceforge.net
bu_voice_memo() {
  tmp_path=$TMPDIR$(date '+%Y-%m-%d_%H-%M-%S_%Z')
  if [ -n "$*" ]; then
    title="${*// /_}"
    tmp_path=$tmp_path"__"$title
  fi
  tmp_path=$tmp_path".ogg"

  echo "Recording! Press Ctrl-C to stop."
  # gain: increases volume
  rec --guard $tmp_path gain +15

  # Reason for \r: https://unix.stackexchange.com/a/26578
  echo -n "\rDo you want to save that recording? [y/n] "
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    out_path="$USTASB_DOCS_DIR_PATH/ustasb/journal/voice_memos/$(basename $tmp_path)"
    # sample rates: https://manual.audacityteam.org/man/sample_rates.html
    sox $tmp_path --rate 22050 --channels 1 $out_path
    rm $tmp_path
    echo "Saved! Destination: $out_path"
  else
    rm $tmp_path
    echo "Destroyed!"
  fi
}
