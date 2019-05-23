let s:dein_dir = expand('~/.cache/dein')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml('~/.config/nvim/dein.toml',        {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml',   {'lazy': 1})
  call dein#load_toml('~/.config/nvim/dein_neo.toml',    {'lazy': 1})
  call dein#load_toml('~/.config/nvim/dein_lsp.toml',    {'lazy': 1})
  call dein#load_toml('~/.config/nvim/dein_go.toml',     {'lazy': 1})
  call dein#load_toml('~/.config/nvim/dein_python.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
