# List the active Chrome window's tabs' metadata.
def active_window_tabs_metadata(metadata)
  `osascript -e 'set text item delimiters to linefeed' -e 'tell app "Google Chrome" to get #{metadata} of tabs of window 1 as text' }`.split("\n")
end

titles_links = active_window_tabs_metadata('title').zip(active_window_tabs_metadata('url'))

titles_links.each do |title, link|
  title.gsub!(' · ', ' | ') # GitHub fix
  puts "- [#{title}](#{link})" # markdown link
end
