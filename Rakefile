require 'fileutils'

HOME_DIR = File.expand_path('~')

CONFIG_FILES = [
  '.zshrc',
  '.tmux.conf',
  '.vimrc',
  '.agignore',
  '.gitconfig',
  '.gemrc',
  '.ctags',
]

OSX_CONFIG_FILES = [
  '.xvimrc'
]

def is_osx?
  /darwin/ =~ RUBY_PLATFORM
end

def get_vim
  is_osx? ? 'mvim -v' : 'vim'
end

def vim_execute(options)
  system("#{get_vim} #{options}", out: $stdout, err: :out)
end

def customize_vim_colorscheme
  old_color = "call <sid>hi(\"StatusLine\",    s:gui04, s:gui02, s:cterm04, s:cterm02, \"none\")"
  new_color = "call <sid>hi(\"StatusLine\",    s:gui04, s:gui00, s:cterm04, s:cterm00, \"\")"
  cs_file_path = "#{HOME_DIR}/.vim/plugged/base16-vim/colors/base16-tomorrow.vim"
  cs_file = IO.read(cs_file_path)
  return unless cs_file.index(new_color).nil?
  cs_file.sub!(old_color, new_color)
  File.write(cs_file_path, cs_file)
end

desc 'Install Vim plugins'
task :install_vim_plugins => [:install_config_files] do
  FileUtils.rm_rf("#{HOME_DIR}/.vim")

  puts "\nInstalling Vim-Plug..."
  `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  puts "\nInstalling Vim plugins..."
  vim_execute('+PlugInstall +qall')

  customize_vim_colorscheme

  puts "\nDone installing Vim plugins!"
end

desc 'Update Vim plugins'
task :update_vim_plugins => [:install_config_files] do
  puts "\nUpdating Vim plugins..."
  vim_execute('+PlugUpgrade +PlugUpdate +PlugClean! +qall')

  customize_vim_colorscheme

  puts "\nDone updating Vim plugins!"
end

desc 'Place all config files into the home directory'
task :install_config_files => [:install_pure_prompt] do
  config_files = CONFIG_FILES

  if is_osx?
    config_files += OSX_CONFIG_FILES
  end

  config_files.each do |filename|
    dest_path = "#{HOME_DIR}/#{filename}"
    FileUtils.cp(filename, dest_path)

    local_customizations = "#{dest_path}.local"
    open(dest_path, 'a') do |f|
      f.puts "\n" + File.read(local_customizations)
    end if File.exist?(local_customizations)
  end

  # Configure the git editor
  `git config --global core.editor "#{get_vim}"`

  puts 'To apply the new .zshrc settings, execute `source ~/.zshrc`'
end

desc 'Install Pure prompt'
task :install_pure_prompt do
  puts 'Installing Pure prompt...'

  zfunc_path = "#{HOME_DIR}/.zfunctions"
  FileUtils.mkdir(zfunc_path) unless File.directory?(zfunc_path)

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh' \
   -o #{HOME_DIR}/.zfunctions/prompt_pure_setup`
end

task :install => [:install_config_files, :install_vim_plugins]
task :update => [:install_config_files, :update_vim_plugins]

task :default do
  puts 'Run rake -T for options.'
end
