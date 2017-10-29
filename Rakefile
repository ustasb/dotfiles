require 'fileutils'

CONFIG_FILES = [
  '.zshrc',
  '.tmux.conf',
  '.vimrc',
  '.rgignore',
  '.gitconfig',
  '.gemrc',
  '.hushlogin',
].freeze

GPG_CONFIG_FILES = [
  'gpg.conf',
  'gpg-agent.conf',
].freeze

XDG_CONFIG = '.config'.freeze

def log(msg)
  puts "\n===> #{msg}"
end

def neovim_execute(options)
  system("nvim #{options}", out: $stdout, err: :out)
end

def install_gpg_conf_files
  gnupg_dir = `gpgconf --list-dirs homedir`.chomp

  GPG_CONFIG_FILES.each do |filename|
    dest_path = "#{gnupg_dir}/#{filename}"
    FileUtils.cp(filename, dest_path)
  end

  log "Done installing GPG config files!"
end

def install_xdg_conf_files
  xdg_home_config = "#{Dir.home}/#{XDG_CONFIG}"
  FileUtils.mkdir(xdg_home_config) unless File.directory?(xdg_home_config)
  FileUtils.cp_r(Dir.glob("#{XDG_CONFIG}/*"), xdg_home_config)

  log "Done installing XDG config files!"
end

def install_ctags_file
  ctags_dir = "#{Dir.home}/.ctags.d" # universal-ctags
  FileUtils.mkdir(ctags_dir) unless File.directory?(ctags_dir)
  FileUtils.cp('.ctags', "#{ctags_dir}/main.ctags")

  log "Done installing the global ctags file!"
end

task :install_pure_prompt do
  log "Installing Pure prompt..."

  zfunc_path = "#{Dir.home}/.zfunctions"
  FileUtils.mkdir(zfunc_path) unless File.directory?(zfunc_path)

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh' \
   -o #{zfunc_path}/prompt_pure_setup`

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh' \
   -o #{zfunc_path}/async`
end

task :install_config_files => [:install_pure_prompt] do
  install_gpg_conf_files
  install_xdg_conf_files
  install_ctags_file

  CONFIG_FILES.each do |filename|
    dest_path = "#{Dir.home}/#{filename}"
    FileUtils.cp(filename, dest_path)
  end

  log "To apply the new .zshrc settings, execute `source ~/.zshrc`."
end

task :install_vim_plugins => [:install_config_files] do
  FileUtils.rm_rf("#{Dir.home}/.vim")

  log "Installing Vim-Plug..."
  `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  log "Installing Vim plugins..."
  neovim_execute('+PlugInstall +qall')

  log "Done installing Vim plugins!"
end

task :update_vim_plugins => [:install_config_files] do
  log "Updating Vim plugins..."
  neovim_execute('+PlugUpgrade +PlugUpdate +PlugClean! +qall')

  log "Done updating Vim plugins!"
end

desc 'Install all config files to $HOME and install Vim plugins forcefully'
task :install => [:install_config_files, :install_vim_plugins]

desc 'Install all config files to $HOME and only update outdated Vim plugins'
task :update => [:install_config_files, :update_vim_plugins]

task :default do
  puts 'Run rake -T for options.'
end
