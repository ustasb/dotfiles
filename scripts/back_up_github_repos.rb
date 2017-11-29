# A script to back up my Github repos.

if ARGV.empty?
  puts 'Please supply a backup directory path.'
  exit
else
  BACKUP_DIR = ARGV[0].freeze
end

REPO_NAMES = [
  'artwork',
  'bookbub_omdb',
  'cubecraft',
  'div_tree',
  'docker-rails-template',
  'dotfiles',
  'dunkin_donuts_auto_survey',
  'emoji_soup',
  'grida.js',
  'hitpic_app',
  'hitpic_backend',
  'hitpic_frontend',
  'infinite_jest_music',
  'knightly_partners_dashboard',
  'office_snake',
  'osx_opengl_context',
  'pandata',
  'pandify',
  'paridaez_clothing_combinations',
  'ps1_lint',
  'sfm_pipeline',
  'ustasb_com',
  'ustasb_website',
  'where_in_the_world',
]

GITHUB_BASE_URI = "git@github.com:ustasb"

REPO_NAMES.each do |repo_name|
  repo_url = "#{GITHUB_BASE_URI}/#{repo_name}.git"
  backup_path = "#{BACKUP_DIR}/#{repo_name}"

  if File.exist?(backup_path)
    system("cd #{backup_path} && git fetch origin master && git reset --hard origin/master")
  else
    system("git clone #{repo_url} #{backup_path}")
  end
end
