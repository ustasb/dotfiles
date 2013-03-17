require 'fileutils'

HOME_DIR = File.expand_path('~')

desc 'Put .vim/ into $HOME'
task :update_sys_vim do
  vim_dir = HOME_DIR + '/.vim'
  FileUtils.rm_rf vim_dir
  FileUtils.cp_r '.vim', vim_dir
end

desc 'Put .vimrc into $HOME'
task :update_sys_vimrc do
  FileUtils.cp '.vimrc', HOME_DIR + '/.vimrc'
end

desc 'Put .bashrc and .bash_profile into $HOME'
task :update_sys_bashrc do
  FileUtils.cp '.bash_profile', HOME_DIR + '/.bash_profile'
  FileUtils.cp '.bashrc', HOME_DIR + '/.bashrc'
  puts 'To apply your .bashrc settings, execute: source ~/.bashrc'
end

task :update_sys => [:update_sys_bashrc, :update_sys_vim, :update_sys_vimrc]

task :default do
  puts 'Run rake -T for commands.'
end

