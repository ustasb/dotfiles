# Creates convenient symbolic links for interacting with my Cryptomator drive.
# Solves: https://github.com/cryptomator/cryptomator/issues/464
# Tested on OS X Sierra

MOUNTED_DRIVE_NAME = ENV['USTASB_CRYPTOMATOR_MOUNTED_DRIVE_NAME']
UNENCRYPTED_SYM_LINK_PATH = ENV['USTASB_UNENCRYPTED_SYM_LINK_PATH']

def create_sym_link(source, dest)
  system("ln -sfh #{source} #{dest}")
  puts "Created a symbolic link between `#{source}` and `#{dest}`!"
end

def get_mounted_volume_path
  @volume_path_match ||= `mount`.match(/\/Volumes\/#{MOUNTED_DRIVE_NAME}\S*/)
  @volume_path_match == nil ? nil : @volume_path_match[0]
end

def remove_dead_volumes
  dead_volumes = Dir.glob("/Volumes/#{MOUNTED_DRIVE_NAME}*")
  dead_volumes -= [get_mounted_volume_path].compact

  if dead_volumes.length > 0
    puts "Removing dead volumes..."
    system("sudo rm -rf #{dead_volumes.join(' ')}")
  end
end

def create_unencrypted_sym_link
  volume_path = get_mounted_volume_path
  create_sym_link(volume_path, UNENCRYPTED_SYM_LINK_PATH)
end

def remove_unencrypted_sym_link
  if File.exists?(UNENCRYPTED_SYM_LINK_PATH)
    File.delete(UNENCRYPTED_SYM_LINK_PATH)
  end
end

def main
  remove_dead_volumes
  remove_unencrypted_sym_link

  if get_mounted_volume_path == nil
    puts "Could not find the Cryptomator drive: #{MOUNTED_DRIVE_NAME}"
    exit
  end

  create_unencrypted_sym_link
end

main
