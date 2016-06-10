set nocompatible
filetype plugin on

" key mappings
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <f5> :!ctags -R<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" global configuration
set history=200
set number
set hidden
set nobackup
set backspace=indent,eol,start
set ruler

" search
set hlsearch
set incsearch
set wildmode=longest,list

" indent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=0

"
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" plugin manager
call plug#begin('~/.vim/plugged')
Plug 'matchit.zip'
Plug 'netrw.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/syntastic'
Plug 'altercation/vim-colors-solarized'
Plug 'puppetlabs/puppet-syntax-vim'
call plug#end()

" color schema"
syntax enable
set background=dark
colorscheme solarized

" Recommended settings for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['javascript'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
