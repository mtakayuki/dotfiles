" key mappings
let mapleader = "\<Space>"

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <silent> <f5> :source $MYVIMRC<CR>
" nnoremap <f5> :!ctags -R<CR>

" cnoremap <C-p> <Up>
" cnoremap <C-n> <Down>
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> <CR> wildmenumode() ? "\<C-e>" : "\<CR>"

augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END
