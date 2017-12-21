# Usage: `ruby build_full_journal.rb`

INPUT_ENTRIES_PATH = File.expand_path("#{ENV['USTASB_NOTES_DIR_PATH']}/ustasb/journal/entries")
OUTPUT_JOURNAL_PATH = File.expand_path("#{ENV['USTASB_NOTES_DIR_PATH']}/ustasb/journal/full_journal.md.asc")

entries = []

Dir.glob("#{INPUT_ENTRIES_PATH}/*").sort.reverse.each do |entry_path|
  # entry header
  header = File.basename(entry_path)
  header.gsub!(/\..*$/, '') # Remove the extension.
  header = "\n# #{header}\n"
  entries << header

  # entry body
  if /\.asc$/.match?(entry_path)
    puts "\n==> Decrypting: #{entry_path}\n\n"
    # If the decrypted file is signed, the signature is also verified.
    body = `gpg --decrypt --local-user brianustas@gmail.com #{entry_path}`
  else
    puts "\n==> Reading: #{entry_path}\n\n"
    body = File.read(entry_path)
  end

  body.strip!
  body.gsub!(/^#/, '##') # Decrease Markdown heading levels.

  entries << body
end

full_journal = "% Brian's Journal\n" + entries.join("\n")

IO.popen('gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com', 'r+') do |io|
  io.write(full_journal)
  io.close_write
  File.write(OUTPUT_JOURNAL_PATH, io.read)
end

puts "\nDone! Your encrypted journal lives here:\n#{OUTPUT_JOURNAL_PATH}"
