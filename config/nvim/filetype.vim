" indent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

augroup fileTypeSetting
  autocmd!
  autocmd FileType groovy setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType go setlocal noexpandtab tabstop=4 softtabstop=0 shiftwidth=4
  autocmd FileType python BracelessEnable +fold
  autocmd Filetype javascript setlocal makeprg=webpack
augroup END
