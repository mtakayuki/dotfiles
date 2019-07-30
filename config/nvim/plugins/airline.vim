set laststatus=2

" let g:airline_powerline_fonts = 1
let g:airline_theme = 'badwolf'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
let g:airline_section_c = '%t'
let g:airline_section_x = '%{&filetype}'
let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'
let g:airline#extensions#default#section_truncate_width = {}
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
