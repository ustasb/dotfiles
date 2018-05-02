require 'fileutils'

DOTFILES_DIR = File.dirname(__FILE__)

def log(msg)
  puts "\n===> #{msg}"
end

def neovim_execute(options)
  system("nvim #{options}", out: $stdout, err: :out)
end

task :install_pure_prompt do
  log "Installing Pure prompt..."

  pure_path = "#{Dir.home}/.pure_prompt"
  FileUtils.mkdir(pure_path) unless File.directory?(pure_path)

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh' \
   -o #{pure_path}/prompt_pure_setup`

  `curl 'https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh' \
   -o #{pure_path}/async`
end

task :install_config_files => [:install_pure_prompt] do
  local_home_path = "#{DOTFILES_DIR}/home"

  config_paths = Dir.glob("#{local_home_path}/**/*", File::FNM_DOTMATCH)

  config_paths.sort! # directories first

  config_paths.each do |path|
    next if (/^(.|.DS_Store)$/ =~ File.basename(path)) == 0

    dest_path = path.sub(local_home_path, Dir.home)

    if File.directory?(path)
      FileUtils.mkdir_p(dest_path)
    else
      FileUtils.ln_s(path, dest_path, force: true)
    end
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

task :define_term_capabilities do
  `/bin/sh #{DOTFILES_DIR}/scripts/fix_term.sh`
  log "~/.terminfo/ created! Restart tmux and/or your shell."
end

desc 'Install all config files to $HOME and install Vim plugins forcefully.'
task :install => [:define_term_capabilities, :install_config_files, :install_vim_plugins]

desc 'Install all config files to $HOME and only update outdated Vim plugins.'
task :update => [:install_config_files, :update_vim_plugins]

task :default do
  puts 'Run rake -T for options.'
end
