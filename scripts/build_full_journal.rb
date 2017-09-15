# Usage: `ruby build_full_journal.rb`

INPUT_ENTRIES_PATH = File.expand_path("#{ENV['USTASB_NOTES_DIR_PATH']}/ustasb/journal/entries")
OUTPUT_JOURNAL_PATH = File.expand_path("#{ENV['USTASB_NOTES_DIR_PATH']}/ustasb/journal/full_journal.md.asc")

decrypted_entries = []

Dir.glob("#{INPUT_ENTRIES_PATH}/*.asc").sort.reverse.each do |entry_path|
  # entry header
  header = File.basename(entry_path)
  header.gsub!(/\..*$/, '') # Remove the extension.
  header = "\n## #{header}\n"
  decrypted_entries << header

  # entry body
  body = `gpg --decrypt --local-user brianustas@gmail.com #{entry_path}`
  body.strip!
  body.gsub!(/^#/, '###') # Decrease Markdown heading levels.
  decrypted_entries << body
end

full_journal = decrypted_entries.join("\n")
full_journal = "# Brian's Journal\n" + full_journal

IO.popen('gpg --encrypt --sign --local-user brianustas@gmail.com --recipient brianustas@gmail.com', 'r+') do |io|
  io.write(full_journal)
  io.close_write
  File.write(OUTPUT_JOURNAL_PATH, io.read)
end

puts "\nDone! Your encrypted journal lives here:\n#{OUTPUT_JOURNAL_PATH}"
