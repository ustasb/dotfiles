import os
from FinderSidebarEditor import FinderSidebar

sidebar = FinderSidebar()
home_path = os.path.expanduser('~')
cloud_drive_path = os.environ['USTASB_CLOUD_DIR_PATH']
unencrypted_path = os.environ['USTASB_UNENCRYPTED_DIR_PATH']

sidebar.removeAll()
sidebar.add('/Volumes')
sidebar.add('/Applications')
sidebar.add(cloud_drive_path)
sidebar.add(cloud_drive_path + '/ustasb_not_encrypted/ebooks')
sidebar.add(unencrypted_path + '/pictures')
sidebar.add(os.environ['USTASB_DOCS_DIR_PATH'])
sidebar.add(home_path + '/projects')
sidebar.add(home_path + '/Downloads')
sidebar.add(home_path + '/Desktop')
sidebar.add(unencrypted_path)
sidebar.add(home_path)
