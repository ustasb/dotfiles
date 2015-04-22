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

def log(msg)
  puts "===> #{msg}"
end

def is_osx?
  /darwin/ =~ RUBY_PLATFORM
end

def get_vim
  is_osx? ? 'mvim -v' : 'vim'
end

def vim_execute(options)
  system("#{get_vim} #{options}", out: $stdout, err: :out)
end

def customize_tomorrow_dark_colorscheme
  customizations = [
    [%q{call <sid>hi("Search",        s:gui03, s:gui0A, s:cterm03, s:cterm0A,  "")},
     %q{call <sid>hi("Search",        s:gui00, s:gui0A, s:cterm00, s:cterm0A,  "bold")}],
    [%q{call <sid>hi("StatusLine",    s:gui04, s:gui02, s:cterm04, s:cterm02, "none")},
     %q{call <sid>hi("StatusLine",    s:gui04, s:gui00, s:cterm04, s:cterm00, "")}],
  ]

  cs_file_path = "#{HOME_DIR}/.vim/plugged/base16-vim/colors/base16-tomorrow.vim"
  cs_file = IO.read(cs_file_path)
  customizations.each do |old_color, new_color|
    cs_file.sub!(old_color, new_color)
  end
  File.write(cs_file_path, cs_file)
end

desc 'Install Vim plugins'
task :install_vim_plugins => [:install_config_files] do
  FileUtils.rm_rf("#{HOME_DIR}/.vim")

  log "Installing Vim-Plug..."
  `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  log "Installing Vim plugins..."
  vim_execute('+PlugInstall +qall')

  customize_tomorrow_dark_colorscheme

  log "Done installing Vim plugins!"
end

desc 'Update Vim plugins'
task :update_vim_plugins => [:install_config_files] do
  log "Updating Vim plugins..."
  vim_execute('+PlugUpgrade +PlugUpdate +PlugClean! +qall')

  customize_tomorrow_dark_colorscheme

  log "Done updating Vim plugins!"
end

desc 'Place all config files into the home directory'
task :install_config_files => [:install_pure_prompt] do
  config_files = CONFIG_FILES
  config_files += OSX_CONFIG_FILES if is_osx?

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

  log "To apply the new .zshrc settings, execute `source ~/.zshrc`"
end

desc 'Install Pure prompt'
task :install_pure_prompt do
  log "Installing Pure prompt..."

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
