# Professionalize your Pandoc Markdown!
# It's far from perfect but does a good job at cleaning up messy notes.
# - Adds periods and capitalization where appropriate
# - titleizes headers
# - misc cleanup
# required install: `pip install titlecase`

require 'shellwords'

TEST_MODE = false

NEWLINE_MARKER = 'N' * 5

WORD_RE = /(\w|[:'"%])+/
# Must contain at least 3 words.
SENTENCE_WORDS_RE = /(#{WORD_RE}\p{Blank}+){2}#{WORD_RE}/
SENTENCE_END_ITEMS_RE = /\.|:|!|\?/

# Pandoc title and Markdown headers
HEADER_MARKER_RE = /%|\#{1,}/
HEADER_RE = /(^#{HEADER_MARKER_RE}.*$)/

# Find continued lines split by a newline.
LINES_TO_CONCAT_RE = %r{
  (?<=\S)           # look behind for a non-space character
  \n                # match newline
  (?!\s*(\n|-|\*))  # look ahead and ignore if the next line starts with a newline or is a new list item
}x

LINES_NEEDING_PERIOD_RE = %r{
 (^
   (?!#{HEADER_MARKER_RE})       # ignore headers
   .*?
   #{SENTENCE_WORDS_RE}
   .*?
   (?<!#{SENTENCE_END_ITEMS_RE}) # match up until punctuation
 $)
}x

SENTENCES_TO_CAPITALIZE_RE = %r{
  (
    #{SENTENCE_WORDS_RE}
    .*?
    #{SENTENCE_END_ITEMS_RE}
  )
}x

def professionalize(input)
  output = input.dup.chomp

  # flatten newlines (makes capitalization easier)
  output.gsub!(LINES_TO_CONCAT_RE, NEWLINE_MARKER)

  # Add periods to the end of sentences.
  output.gsub!(LINES_NEEDING_PERIOD_RE, '\1.')

  # capitalize sentences
  output.dup.scan(SENTENCES_TO_CAPITALIZE_RE) do |m|
    sentence = m.first.dup
    sentence[0] = sentence[0].upcase
    output.sub!(m.first, sentence)
  end

  # titleize headers
  output.dup.scan(HEADER_RE).each do |m|
    output.sub!(m.first, `titlecase #{Shellwords.escape(m.first)}`)
  end

  # Remove extra spaces.
  # e.g. "end.  start" -> "end. start"
  output.gsub!(/\.\p{Blank}{2,4}(\S)/, '. \1')

  # misc
  output.gsub!(/\bi\b/, 'I')
  output.gsub!("i'", "I'")

  # Add back the newlines.
  output.gsub!(NEWLINE_MARKER, "\n")

  output
end

if TEST_MODE
  input = <<~EOF
    % this is a title

    # this is header 1

    this is some text. and some more. and here
    is a line that wraps around. and another line
    that does the same but with $pecial(-)chars

    ## this is header 2

    here is a list of things:

    - don't change
    - i'm going to (very loudly) shout!
    - 100% of this is true
    * what am i talking about?
    - a line without a period that continues
      to the line below
        - an indented line with no (comment) period
            - another indented line with no period
    * and we're back
    - http://www.example.com/

    John Apple:
    - he likes Apple products
  EOF
else
  input = ARGV[0] || STDIN.read
end

print professionalize(input)
