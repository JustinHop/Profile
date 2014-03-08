" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

"execute "silent! normal: LoadProfiles python \<CR>"
set omnifunc=pythoncomplete#Complete
let g:flake8_builtins="_,apply"
