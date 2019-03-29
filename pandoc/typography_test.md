% Typography Test

# Header 1

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

## Header 2

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

### Header 3

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

#### Header 4

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

##### Header 5

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

###### Header 6

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum.

## Lists

### Ordered

An ordered list:

1. red
    - square
    - rectangle
1. green
    - circle
1. blue

### Unordered

An unordered list:

- red
- green
    - rectangle
        - circle
        - triangle
- blue
    1. apple
    1. banana
    1. orange
- Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed
  diam nonumy eirmod tempor invidunt ut labore et dolore magna
  aliquyam erat, sed diam voluptua.

## Links

- [Brian's Website](/)
- raw link: https://brianustas.com/

## Images

![The Batman](https://vignette.wikia.nocookie.net/warcommander/images/0/09/Batman.jpg)

## Code

inline code: `sum = 1 + 1` (insightful comment)

code block:

```ruby
require 'set'
set = Set.new
```

long code block:

    require 'set'
    set = Set.new
    long_line = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]

long code block with syntax highlighting:

```ruby
require 'set'
set = Set.new
long_line = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]
```

### No-Wrap `pre` Tag

<div class="nowrap">
```vim
augroup AG_Misc
  autocmd!

  autocmd BufReadPost * call ResetCursorPosition()

  autocmd FileType * autocmd BufWritePre <buffer> call StripTrailingWhitespaces()

  " Don't auto-comment the next line on Enter.
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
```
</div>

Notice how it:
- expands when hovered over
- resizes with the `.post` container
- wraps when JavaScript is disabled

It doesn't expand when it doesn't need to:

<div class="nowrap">
```vim
" quickly quit
command! Q :qa
nnoremap Q :qa<CR>
```
</div>

## LaTeX Math

inline math: $e^{i\pi} + 1 = 0$ (insightful comment)

math block:
Highlight
$$
x = \frac{{ - b \pm \sqrt {b^2 - 4ac}}} {{2a}}
$$

## Misc

horizontal rule:

---

block quote:

> Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
> tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
> vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
> no sea takimata sanctus est Lorem ipsum dolor sit amet.
>
> Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
> tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
> vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
> no sea takimata sanctus est Lorem ipsum dolor sit amet.
