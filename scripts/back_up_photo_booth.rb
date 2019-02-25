# Usage: `ruby back_up_photo_booth.rb`

require 'fileutils'

def get_filename(pb_filename)
  m = pb_filename.match(/(?<month>\d+)-(?<day>\d+)-(?<year>\d+) at (?<hour>\d+)\.(?<minute>\d+) (?<pm>\w\w)\s?(?<num>#\d+)?/)

  hour = m[:hour]
  if m[:pm] == 'PM'
    hour = hour.to_i + 12
    hour = 0 if hour == 24
  end

  time = Time.new('20' + m[:year], m[:month], m[:day], hour, m[:minute])

  outfile = time.strftime('%FT%H%M') # => 2007-11-19T0837
  outfile += "_#{m[:num]}" if m[:num]
  outfile + File.extname(pb_filename)
end

PHOTO_BOOTH_CONTENT = "#{Dir.home}/Pictures/Photo Booth Library/Pictures"
BACKUP_DIR = "#{ENV['USTASB_UNENCRYPTED_DIR_PATH']}/backups/photo_booth"

unless Dir.exists?(BACKUP_DIR)
  puts "Backup directory doesn't exist: #{BACKUP_DIR}"
  puts "Exiting..."
  exit
end

Dir.glob(PHOTO_BOOTH_CONTENT + '/*').each do |file|
  outpath = "#{BACKUP_DIR}/#{get_filename(File.basename(file))}"

  if File.exists?(outpath)
    puts "skipping: #{file}"
  else
    puts "backing up: #{file}"
    FileUtils.cp(file, outpath)
  end
end
