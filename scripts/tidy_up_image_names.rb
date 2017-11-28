# A script to tidy up image names.
# Usage:
# - gem install exifr
# - ruby tidy_up_image_names.rb <path>

require 'exifr/jpeg'

if ARGV.empty?
  puts 'Please supply an image directory path.'
  exit
else
  IMAGE_DIR = ARGV[0].freeze
end

PNG_REGEX = /\.png$/i
JPEG_REGEX = /\.jpe?g$/i
IGNORE_PATTERNS = [
  /photo_booth_backup/,
].freeze

def rename(old_path, new_path)
  puts "renaming: #{old_path}"
  File.rename(old_path, new_path)
  puts " renamed: #{new_path}\n\n"
end

def sanitize_basename(path)
  basename = File.basename(path)
  new_basename = basename.clone

  new_basename.sub!(JPEG_REGEX, '.jpg') # jpg
  new_basename.sub!(PNG_REGEX, '.png') # png
  new_basename.gsub!(/\s+/, '_') # no spaces

  path.sub(basename, new_basename)
end

def timestamp_basename(path)
  basename = File.basename(path)

  # JPEG only
  return path unless JPEG_REGEX.match?(basename)

  # Don't timestamp custom names.
  return path unless /^(IMG_|File_)/.match?(basename)

  date_time = EXIFR::JPEG.new(path).date_time
  using_exif = true

  if date_time.nil?
    date_time = File.birthtime(path)
    using_exif = false
  end

  new_basename = date_time.strftime('%Y-%m-%d_%H-%M-%S')
  new_basename = "#{new_basename}#{using_exif ? '_exif' : nil}.jpg"

  path.sub(basename, new_basename)
end

def unique_basename(path)
  i = 1
  new_path = path
  template = path.sub(/(\.\w+)$/, '_(%01d)\1') # foo.jpg -> foo_(%01d).jpg

  while File.exist?(new_path)
    i += 1
    new_path = template % i
  end

  new_path
end

def tidy_up_image_names
  stats = { considered: 0, renamed: 0 }

  paths = Dir.glob("#{IMAGE_DIR}/**/*.{jpeg,JPEG,jpg,JPG,png,PNG}")

  paths.each do |path|
    stats[:considered] += 1

    ignore = false
    IGNORE_PATTERNS.each do |pattern|
      if pattern.match?(path)
        ignore = true
        break
      end
    end
    if ignore
      puts "skipping: #{path}"
      puts "matches ignore pattern\n\n"
      next
    end

    begin
      new_path = timestamp_basename(path)
    rescue EXIFR::MalformedJPEG
      puts "skipping: #{path}"
      puts "malformed JPEG\n\n"
      next
    end

    new_path = sanitize_basename(new_path)

    if new_path != path
      # When the case is different, overwrite the existing.
      if new_path.downcase != path.downcase
        new_path = unique_basename(new_path)
      end

      rename(path, new_path)
      stats[:renamed] += 1

      sleep 0.5 # HACK: Don't overwhelm Cryptomator volumes.
    end
  end

  puts "\nDone!"
  puts "==> considered: #{stats[:considered]}"
  puts "==> renamed: #{stats[:renamed]}"
  puts "==> skipped: #{stats[:considered] - stats[:renamed]}"
end

tidy_up_image_names
