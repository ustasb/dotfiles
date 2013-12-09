require 'fileutils'

HOME_DIR = File.expand_path('~')
CONFIG_FILES = [
  '.zshrc',
  '.tmux.conf',
  '.vimrc',
  '.xvimrc',
  '.agignore',
]

desc 'Install Vim plugins'
task :install_vim_plugins => [:install_config_files] do
  FileUtils.rm_rf("#{HOME_DIR}/.vim")

  puts "\nInstalling Vundle..."
  `git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

  puts "\nInstalling Vim plugins..."
  `vim +BundleInstall +qall`

  puts "\nDone installing Vim plugins!"
end

desc 'Place all config files into the home directory'
task :install_config_files => [:install_pure_prompt] do
  CONFIG_FILES.each do |filename|
    dest_path = "#{HOME_DIR}/#{filename}"

    if File.exist?(dest_path)
      FileUtils.mv(dest_path, "#{dest_path}.original")
    end

    FileUtils.cp(filename, dest_path)
  end

  puts 'To apply the new .zshrc settings, execute `source ~/.zshrc`'
end

desc 'Install Pure prompt'
task :install_pure_prompt do
  puts 'Installing Pure prompt...'
  `curl 'https://raw.github.com/sindresorhus/pure/master/pure.zsh' \
   -o /usr/local/share/zsh/site-functions/prompt_pure_setup`
end

task :update_sys => [:install_config_files, :install_vim_plugins]

task :default do
  puts 'Run rake -T for options.'
end
