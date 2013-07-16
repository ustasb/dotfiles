require 'fileutils'

HOME_DIR = File.expand_path('~')

desc 'Install Vim preferences'
task :update_vim_settings do
  FileUtils.cp('.vimrc', HOME_DIR + '/.vimrc')
  FileUtils.rm_rf(HOME_DIR + '/.vim')

  # Install Vundle + Vim plugins
  puts "\nInstalling Vundle..."
  `git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

  puts "\nInstalling Vim plugins..."
  `vim +BundleInstall +qall`

  puts "\nDone installing Vim settings!"
end

desc 'Put .bashrc and .bash_profile into $HOME'
task :update_sys_bashrc do
  FileUtils.cp('.bash_profile', HOME_DIR + '/.bash_profile')
  FileUtils.cp('.bashrc', HOME_DIR + '/.bashrc')
  puts 'To apply the new .bashrc settings, execute: source ~/.bashrc'
end

task :update_sys => [:update_sys_bashrc, :update_vim_settings]

task :default do
  puts 'Run rake -T for commands.'
end

