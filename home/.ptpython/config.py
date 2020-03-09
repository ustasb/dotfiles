# ptpython: https://github.com/jonathanslenders/ptpython
# options: https://github.com/jonathanslenders/ptpython/blob/master/examples/ptpython_config/config.py
# TODO: "~/.ptpython/config.py is deprecated, move your configuration to /Users/ustasb/Library/Application Support/ptpython/config.py"

def configure(repl):
    repl.true_color = True

    repl.vi_mode = True

    repl.prompt_style = 'ipython'

    repl.show_line_numbers = True

    repl.show_status_bar = False

    repl.show_signature = True

    repl.show_docstring = True

    # 'v' in Vi navigation mode will open the input in $EDITOR.
    repl.enable_open_in_editor = True

    repl.insert_blank_line_after_output = False

    repl.confirm_exit = False
