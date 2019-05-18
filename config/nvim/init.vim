filetype off
filetype plugin indent off

if has('mac')
  let g:python_host_prog='/usr/local/bin/python'
  let g:python3_host_prog='/usr/local/bin/python3'
else
  let g:python_host_prog='/usr/bin/python'
  let g:python3_host_prog='/usr/bin/python3'
endif

let s:script_dir = expand('<sfile>:p:h')

function! s:source_rc(path, ...) abort
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = s:script_dir . '/'. a:path
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

" load dein
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

call s:source_rc('mappings.vim')
call s:source_rc('options.vim')
call s:source_rc('filetype.vim')
call s:source_rc('dein.vim')

" color schema
syntax enable
set background=dark
colorscheme solarized

autocmd QuickFixCmdPost "grep" cwindow

filetype plugin indent on
