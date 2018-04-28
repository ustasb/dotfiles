// jupyter-vim-binding
// https://github.com/lambdalisue/jupyter-vim-binding
require([
  'nbextensions/vim_binding/vim_binding',
], function() {
  CodeMirror.Vim.map('jk', '<Esc>', 'insert');
});
