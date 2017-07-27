# Creates a secure archive of my digital stuff and puts it on S3.
# Tested on OS X Sierra

require 'tmpdir'
require 'aws-sdk'

# To decrypt and unarchive into the current directory:
# gzcat my_backup.tar.gpg.gz | gpg --decrypt --local-user brianustas@gmail.com | tar -x

BRIAN_GPG_IDENTITY = 'brianustas@gmail.com'
RSYNC_CLAUSE = 'rsync --archive --ignore-existing --checksum --exclude Icon? --exclude .DS_Store'
MAX_RSYNC_RETRY_COUNT = 3
GOOGLE_DRIVE_PATH = "#{Dir.home}/Google\\ Drive"
UNENCRYPTED_SYM_LINK_PATH = ENV['USTASB_UNENCRYPTED_SYM_LINK_PATH']
ENCRYPTED_FOLDER_REL_PATH = ENV['USTASB_ENCRYPTED_FOLDER_REL_PATH']
S3_BACKUP_BUCKET_NAME = ENV['USTASB_S3_BACKUP_BUCKET_NAME']

def log(msg, indent_level = 0)
  puts "#{'===' * indent_level}==> #{msg}"
end

def main
  log("Looking for: #{UNENCRYPTED_SYM_LINK_PATH}")
  if `ls #{UNENCRYPTED_SYM_LINK_PATH}`.empty?
    log("Error: Couldn't find or was empty: #{UNENCRYPTED_SYM_LINK_PATH}", 1)
    log("Is Cryptomator running and have you run `symlink_cryptomator`? Exiting.", 1)
    exit
  end
  log("Found!", 1)

  now = Time.now.utc
  temp_dir = Dir.mktmpdir
  backup_path = "#{temp_dir}/backup-#{now.to_i}"

  log("Creating backup directory: #{backup_path}")
  `mkdir -p #{backup_path}`

  log("Copying non-encrypted data from: #{GOOGLE_DRIVE_PATH}")
  log("Excluding: #{ENCRYPTED_FOLDER_REL_PATH}", 1)
  `#{RSYNC_CLAUSE} --exclude #{ENCRYPTED_FOLDER_REL_PATH} #{GOOGLE_DRIVE_PATH}/* #{backup_path}`

  log("Copying encrypted data from: #{UNENCRYPTED_SYM_LINK_PATH}")
  cmd = "#{RSYNC_CLAUSE} #{UNENCRYPTED_SYM_LINK_PATH}/* #{backup_path}/#{ENCRYPTED_FOLDER_REL_PATH}"
  retry_count = 0
  until system(cmd) # Relies on the --ignore-existing flag to not redo work.
    retry_count += 1

    if retry_count > MAX_RSYNC_RETRY_COUNT
      log("Error: rsync failed #{MAX_RSYNC_RETRY_COUNT} times! Exiting.", 1)
      exit
    end

    log("Retrying...", 1)
  end
  log("Success!", 1) if retry_count > 0

  # Seems to solve the 'gpg: card error' issue.
  log("Killing gpg-agent (forces a restart)...")
  `pkill gpg-agent`

  archive_path = "#{backup_path}.tar.gpg.gz"
  log("Creating a signed, encrypted, gzipped archive: #{archive_path}")

  # Use private key.
  # `tar -c -C #{backup_path} . | gpg --no-armor --sign --local-user #{BRIAN_GPG_IDENTITY} --encrypt --recipient #{BRIAN_GPG_IDENTITY} | gzip > #{archive_path}`
  # Use symmetric password.
  `tar -c -C #{backup_path} . | gpg --no-armor --sign --local-user #{BRIAN_GPG_IDENTITY} --symmetric | gzip > #{archive_path}`

  credentials = Aws::Credentials.new(ENV['USTASB_AWS_ACCESS_KEY_ID'], ENV['USTASB_AWS_SECRET_ACCESS_KEY'])
  s3_key = "#{now.strftime('%Y/%m/%d')}/#{File.basename(archive_path)}"
  log("Uploading archive to S3 as: #{S3_BACKUP_BUCKET_NAME}/#{s3_key}")
  Aws::S3::Resource.new(region: ENV['USTASB_AWS_REGION'], credentials: credentials)
    .bucket(S3_BACKUP_BUCKET_NAME)
    .object(s3_key)
    .upload_file(archive_path)

  log("Done!")
ensure
  log("Cleaning up...")
  `rm -rf #{temp_dir}`
end

main
