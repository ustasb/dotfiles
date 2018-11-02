# Render Markdown files as HTML using custom CSS + MathJax.

require 'optparse'
require 'shellwords'

$argv = {}

def cmd(str)
  `#{str.gsub!(/\s+/, ' ')}`
end

def parse_args
  parser = OptionParser.new do |opts|
    opts.banner = 'Usage: markdown_to_html.rb [options]'

    opts.on('-i', '--input [PATH]', 'input Markdown path') do |path|
      $argv[:input_path] = File.expand_path(path)
    end

    opts.on('-o', '--output [PATH]', 'output HTML path') do |path|
      $argv[:output_path] = File.expand_path(path)
    end

    opts.on('-c', '--open-in-chrome', 'open in Google Chrome') do
      $argv[:open_in_chrome] = true
    end
  end

  parser.parse!

  if $argv[:input_path].nil? || !File.exists?($argv[:input_path])
    puts 'Missing input Markdown path! Exiting...'
    abort
  end

  if $argv[:output_path].nil?
    puts 'Missing output HTML path! Exiting...'
    abort
  end
end

def main
  parse_args

  md_to_html_cmd = <<-EOF
    pandoc
      --from markdown+smart+autolink_bare_uris+lists_without_preceding_blankline+emoji
      --to=html5
      --self-contained
      --table-of-contents
      --template="#{Dir.home}/dotfiles/pandoc/html_template.html"
      --css #{Dir.home}/dotfiles/pandoc/docs.css
      --mathjax=""
      --resource-path #{ENV['USTASB_DOCS_IMAGE_DIR_PATH']}:#{Dir.home}/Desktop
      --output #{Shellwords.escape($argv[:output_path])}
      #{Shellwords.escape($argv[:input_path])}
  EOF

  cmd(md_to_html_cmd)

  if $argv[:open_in_chrome]
    chrome_uri = "file://#{$argv[:output_path]}"
    cmd("osascript #{Dir.home}/dotfiles/scripts/chrome_reload_path.scpt #{chrome_uri}")
  end
end

main
