all

# unordered list indentation
rule 'MD007', indent: 4

# First line in file should be a top level header.
# reason disabled: Using Pandoc's title blocks.
exclude_rule 'MD041'

# Lists should be surrounded by blank lines.
# reason disabled: Using Pandoc's lists_without_preceding_blankline.
exclude_rule 'MD032'
