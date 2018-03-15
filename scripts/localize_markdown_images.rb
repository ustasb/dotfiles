# Scans all Markdown documents and localizes images. A local path for each
# image link is created under PANDOC_IMAGE_RESOURCE_PATH. If the image
# doesn't exist, the image is fetched (locally or over HTTP) and put into the
# correct path. Next, the Markdown image reference is updated. Finally, all
# unreferenced and empty directories under PANDOC_IMAGE_RESOURCE_PATH are
# removed.

require 'fileutils'
require 'open-uri'
require 'set'
require 'tempfile'
require 'uri'

DOCS_PATH = ENV['USTASB_DOCS_DIR_PATH']
# Value of Pandoc's --resource-path argument.
PANDOC_IMAGE_RESOURCE_PATH = ENV['USTASB_DOCS_IMAGE_DIR_PATH']
MARKDOWN_IMAGE_LINK_REGEX = /\! \[.*?\] \((.+?)\)/x # format: ![optional caption](link)

expected_image_paths = Set.new

Dir.glob("#{DOCS_PATH}/**/*").each do |doc|
  # Only consider Markdown files.
  next unless /\.md$/.match?(doc) && File.file?(doc)

  # Unique image folder for this document.
  doc_image_folder_path = doc.sub(DOCS_PATH, PANDOC_IMAGE_RESOURCE_PATH)

  old_doc_contents = File.read(doc).freeze
  new_doc_contents = old_doc_contents.dup

  old_doc_contents.scan(MARKDOWN_IMAGE_LINK_REGEX).each do |match|
    image_path = match.last

    next if /^data:/.match?(image_path) # skip base64 images

    image_uri_path = URI.parse(image_path).path # strip query params if present
    extension = File.extname(image_uri_path)
    # Remove misc unwanted characters.
    basename = File.basename(image_uri_path).sub(extension, '').gsub(/[%.]/, '') + extension

    expected_image_path = File.join(doc_image_folder_path, basename)
    expected_image_paths.add(expected_image_path)

    next if File.exists?(expected_image_path)

    # If the link isn't a URL, its expected home the Desktop.
    uri = /^http/.match?(image_path) ? image_path : File.join("#{Dir.home}/Desktop", image_path)

    tmpfile = Tempfile.new
    begin
      puts "retrieving: #{uri}"
      IO.copy_stream(open(uri), tmpfile)
      tmpfile.close

      unless File.exists?(doc_image_folder_path)
        FileUtils.mkdir_p(doc_image_folder_path)
      end

      puts "==> creating file: #{expected_image_path}"
      FileUtils.cp(tmpfile.path, expected_image_path)

      puts "==> updating document link: #{doc}"
      new_doc_contents.sub!(image_path, expected_image_path.sub(PANDOC_IMAGE_RESOURCE_PATH + '/', ''))
    rescue
      puts "==> FAILED to retrieve: #{uri}"
    ensure
      tmpfile.unlink
    end
  end

  if old_doc_contents != new_doc_contents
    puts "==> writing new document contents: #{doc}"
    File.open(doc, 'w') { |f| f.write(new_doc_contents) }
  end
end

all_image_contents = Dir.glob("#{PANDOC_IMAGE_RESOURCE_PATH}/**/*").to_set

# Find and remove unreferenced images.
images_to_remove = all_image_contents - expected_image_paths
images_to_remove.each do |image|
  next if File.directory?(image)
  puts "removing unreferenced image: #{image}"
  FileUtils.rm(image)
end

# Remove empty image directories.
# sort.reverse to remove "a/b/c" before "a/b".
all_image_contents.sort.reverse.each do |dir|
  next unless File.directory?(dir) && Dir.empty?(dir)
  puts "removing empty directory: #{dir}"
  FileUtils.rmdir(dir)
end
