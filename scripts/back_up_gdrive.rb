# Creates a secure archive of my digital stuff and puts it on S3.
# Tested on OS X Sierra
# Usage: `ruby back_up_gdrive.rb`

require 'shellwords'
require 'tmpdir'

require 'aws-sdk'
require 'optparse'

# To decrypt and unarchive:
# bu_unravel_backup <backup-file>
# or
# cat <backup-file> | gpg --decrypt --local-user brianustas@gmail.com | tar -x

BRIAN_GPG_IDENTITY = 'brianustas@gmail.com'
RSYNC_CLAUSE = 'rsync --archive --ignore-existing --checksum --exclude Icon? --exclude .DS_Store'
MAX_RSYNC_RETRY_COUNT = 5
S3_BACKUP_BUCKET_NAME = ENV['USTASB_S3_BACKUP_BUCKET_NAME']

REQUIRED_DIRS = [
  CLOUD_DIR_PATH = File.expand_path(ENV['USTASB_CLOUD_DIR_PATH']),
  SHARED_DIR_PATH = File.expand_path(ENV['USTASB_SHARED_DIR_PATH']),
  ENCRYPTED_DIR_PATH = File.expand_path(ENV['USTASB_ENCRYPTED_DIR_PATH']),
  UNENCRYPTED_DIR_PATH = File.expand_path(ENV['USTASB_UNENCRYPTED_DIR_PATH']),
]

$argv_options = {}

def parse_args
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: back_up_gdrive.rb [options]"

    opts.on("-a", "--aws", "Backup to AWS") do
      $argv_options[:aws_backup] = true
    end

    opts.on("-d", "--dir [DIRECTORY]", "Output directory") do |dir|
      $argv_options[:output_dir] = dir
    end

    opts.on("--include-shared", "Include the shared/ folder") do
      $argv_options[:include_shared] = true
    end
  end

  parser.parse!

  if $argv_options.empty?
    log("No arguments given! Exiting...")
    puts parser
    exit
  end

  prefix = $argv_options[:include_shared] ? 'Including' : 'Excluding'
  log("#{prefix}: #{SHARED_DIR_PATH}\n\n")

  if $argv_options[:aws_backup]
    log("Backing up to AWS...")
  end

  if $argv_options.key?(:output_dir)
    if $argv_options[:output_dir] == nil
      log("Output directory can't be blank! Exiting...")
      exit
    else
      if Dir.exists?($argv_options[:output_dir])
        log("Backing up to: #{$argv_options[:output_dir]}")
      else
        log("Output directory doesn't exist! Exiting...")
        exit
      end
    end
  end
end

def log(msg, indent_level = 0)
  puts "#{'===' * indent_level}==> #{msg}"
end

def main
  parse_args

  puts "\n"
  log("*** Ensure that your files-to-backup aren't changing during the backup! ***")
  log("Waiting 15 seconds. Unless you cancel, the backup process will continue.")
  sleep(15)
  puts "\n"

  log("Looking for: #{UNENCRYPTED_DIR_PATH}")
  if `ls #{UNENCRYPTED_DIR_PATH}`.empty?
    log("Error: Couldn't find or was empty: #{UNENCRYPTED_DIR_PATH}", 1)
    log("Is Cryptomator running and have you run `bu_symlink_cryptomator`? Exiting.", 1)
    exit
  end
  log("Found!", 1)

  REQUIRED_DIRS.each do |required_dir|
    unless File.directory?(required_dir)
      puts "\n"
      log("ERROR: Required directory does not exist: #{required_dir}")
      log("Exiting...")
      exit
    end
  end

  now = Time.now.utc
  temp_dir = Dir.mktmpdir
  backup_path = "#{temp_dir}/backup-#{now.strftime('%Y-%m-%d_%H-%M-%S')}"

  log("Creating backup directory: #{backup_path}")
  `mkdir -p #{backup_path}`

  log("Copying non-encrypted data from: #{CLOUD_DIR_PATH}")

  exclude_shared = ''
  unless $argv_options[:include_shared]
    log("Excluding: #{SHARED_DIR_PATH}", 1)
    exclude_shared = "--exclude /#{File.basename(SHARED_DIR_PATH)}"
  end

  log("Excluding: #{ENCRYPTED_DIR_PATH}", 1)
  exclude_encrypted = "--exclude /#{File.basename(ENCRYPTED_DIR_PATH)}"

  # Note on the exclusion pattern: https://stackoverflow.com/a/18252050/1575238
  `#{RSYNC_CLAUSE} #{exclude_shared} #{exclude_encrypted} #{Shellwords.escape(CLOUD_DIR_PATH)}/* #{backup_path}`

  log("Copying encrypted data from: #{UNENCRYPTED_DIR_PATH}")
  cmd = "#{RSYNC_CLAUSE} #{UNENCRYPTED_DIR_PATH}/* #{backup_path}/#{File.basename(ENCRYPTED_DIR_PATH)}"
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

  archive_path = "#{backup_path}.tar.gz.gpg"
  log("Creating a gzipped, signed and encrypted archive: #{archive_path}")

  # Use symmetric password.
  `tar -c -z -C #{File.dirname(backup_path)} #{File.basename(backup_path)} | gpg --no-armor --sign --local-user #{BRIAN_GPG_IDENTITY} --symmetric > #{archive_path}`

  if $argv_options[:output_dir]
    log("Copying archive to: #{$argv_options[:output_dir]}")
    FileUtils.cp(archive_path, $argv_options[:output_dir])
  end

  if $argv_options[:aws_backup]
    credentials = Aws::Credentials.new(ENV['USTASB_AWS_ACCESS_KEY_ID'], ENV['USTASB_AWS_SECRET_ACCESS_KEY'])
    s3_key = "full-backups/#{File.basename(archive_path)}"
    log("Uploading archive to S3 as: #{S3_BACKUP_BUCKET_NAME}/#{s3_key}")
    Aws::S3::Resource.new(region: ENV['USTASB_AWS_REGION'], credentials: credentials)
      .bucket(S3_BACKUP_BUCKET_NAME)
      .object(s3_key)
      .upload_file(archive_path)
  end

  log("Done!")
ensure
  log("Cleaning up...")
  `rm -rf #{temp_dir}`
end

main
