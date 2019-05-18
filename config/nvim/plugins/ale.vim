" Apperance
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'E:'
let g:ale_sign_warning = 'W:'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" let g:ale_set_highlights = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'

" Quickfix and Loclist
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_list_vertical = 0

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

let g:ale_linters = {
      \   'python': ['flake8'],
      \   'vim': ['vint'],
      \ }

" Fixers
let g:ale_fix_on_save = 0

let g:ale_fixers = {
      \   'python': ['autopep8', 'yapf', 'isort'],
      \ }

nmap <silent> <Leader>x <Plug>(ale_fix)
