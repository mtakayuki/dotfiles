" indent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set autoindent
set smartindent

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.groovy setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=0 shiftwidth=4
  autocmd FileType python BracelessEnable +fold
augroup END

augroup MyJavaScript
  autocmd!
  autocmd Filetype javascript setlocal makeprg=webpack
augroup END
