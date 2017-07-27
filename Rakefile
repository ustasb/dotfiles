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

GPG_CONFIG_FILES = [
  'gpg.conf',
  'gpg-agent.conf',
]

def log(msg)
  puts "\n===> #{msg}"
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

def install_gpg_conf_files
  if `which gpg2` == ""
    log "Error: You need to install gpg2!"
    exit
  end

  gnupg_dir = `gpgconf --list-dirs homedir`.chomp

  GPG_CONFIG_FILES.each do |filename|
    dest_path = "#{gnupg_dir}/#{filename}"
    FileUtils.cp(filename, dest_path)
  end

  log "Done installing GPG config files!"
end

task :install_vim_plugins => [:install_config_files] do
  FileUtils.rm_rf("#{HOME_DIR}/.vim")

  log "Installing Vim-Plug..."
  `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  log "Installing Vim plugins..."
  vim_execute('+PlugInstall +qall')

  log "Done installing Vim plugins!"
end

task :update_vim_plugins => [:install_config_files] do
  log "Updating Vim plugins..."
  vim_execute('+PlugUpgrade +PlugUpdate +PlugClean! +qall')

  log "Done updating Vim plugins!"
end

task :install_config_files => [:install_pure_prompt] do
  install_gpg_conf_files

  CONFIG_FILES.each do |filename|
    dest_path = "#{HOME_DIR}/#{filename}"
    FileUtils.cp(filename, dest_path)
  end

  log "To apply the new .zshrc settings, execute `source ~/.zshrc`"
end

task :install_pure_prompt do
  log "Installing Pure prompt..."

  zfunc_path = "#{HOME_DIR}/.zfunctions"
  FileUtils.mkdir(zfunc_path) unless File.directory?(zfunc_path)

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh' \
   -o #{HOME_DIR}/.zfunctions/prompt_pure_setup`

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh' \
   -o #{HOME_DIR}/.zfunctions/async`
end

desc 'Install all config files to $HOME and install Vim plugins forcefully'
task :install => [:install_config_files, :install_vim_plugins]

desc 'Install all config files to $HOME and only update outdated Vim plugins'
task :update => [:install_config_files, :update_vim_plugins]

task :default do
  puts 'Run rake -T for options.'
end
