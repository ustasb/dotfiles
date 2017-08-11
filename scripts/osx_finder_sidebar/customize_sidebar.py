import os
from FinderSidebarEditor import FinderSidebar

sidebar = FinderSidebar()
home_path = os.path.expanduser('~')
drive_path = os.environ['USTASB_UNENCRYPTED_SYM_LINK_PATH']

sidebar.removeAll()
sidebar.add(home_path)
sidebar.add(home_path + '/Desktop')
sidebar.add(home_path + '/projects')

# notes
drive_notes = drive_path + '/documents/notes'
notes_symlink = home_path + '/notes'
os.system('ln -sf ' + drive_notes + ' ' + notes_symlink)
sidebar.add(notes_symlink)

# pics
drive_pics = drive_path + '/pictures'
pics_symlink = home_path + '/pics'
os.system('ln -sf ' + drive_pics + ' ' + pics_symlink)
sidebar.add(pics_symlink)

# misc
sidebar.add(home_path + '/Google Drive')
sidebar.add('/Applications')
sidebar.add('/Volumes')
