require 'fileutils'

HOME_DIR = File.expand_path('~')

CONFIG_FILES = [
  '.zshrc',
  '.tmux.conf',
  '.tmux_light_theme.conf',
  '.vimrc',
  '.agignore',
  '.gitconfig',
  '.gemrc',
  '.ctags',
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

def enable_light_theme
  zshrc_path = "#{HOME_DIR}/.zshrc"
  settings = File.read(zshrc_path)
  settings.gsub!('# export USING_LIGHT_THEME=true', 'export USING_LIGHT_THEME=true')
  File.write(zshrc_path, settings)
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
  config_files = CONFIG_FILES

  config_files.each do |filename|
    dest_path = "#{HOME_DIR}/#{filename}"
    FileUtils.cp(filename, dest_path)

    local_customizations = "#{dest_path}.local"
    if File.exist?(local_customizations)
      open(dest_path, 'a') do |f|
        f.puts "\n" + File.read(local_customizations)
      end
    end
  end

  # Configure the git editor
  `git config --global core.editor "#{get_vim}"`

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

task :enable_light_theme do
  enable_light_theme
end

desc 'Install all config files to $HOME and install Vim plugins forcefully'
task :install => [:install_config_files, :install_vim_plugins]

desc 'Install all config files to $HOME and only update outdated Vim plugins'
task :update => [:install_config_files, :update_vim_plugins]

desc 'Same as `update` but enables the light theme'
task :update_light => [:update, :enable_light_theme]

task :default do
  puts 'Run rake -T for options.'
end
