import os
from FinderSidebarEditor import FinderSidebar

sidebar = FinderSidebar()
home_path = os.path.expanduser('~')
gdrive_path = home_path + '/Google Drive'
unencrypted_path = os.environ['USTASB_UNENCRYPTED_DIR_PATH']

sidebar.removeAll()
sidebar.add(home_path)
sidebar.add(unencrypted_path)
sidebar.add(home_path + '/Desktop')
sidebar.add(home_path + '/Downloads')
sidebar.add(home_path + '/projects')
sidebar.add(os.environ['USTASB_DOCS_DIR_PATH'])
sidebar.add(unencrypted_path + '/pictures')
sidebar.add(gdrive_path + '/ustasb_not_encrypted/ebooks')
sidebar.add(gdrive_path)
sidebar.add('/Applications')
sidebar.add('/Volumes')
