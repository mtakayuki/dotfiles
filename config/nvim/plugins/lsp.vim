if (executable('pyls'))
  let s:pyls_path = fnamemodify(g:python_host_prog, ':h') . '/'. 'pyls'
  augroup LspPython
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->[expand(s:pyls_path)]},
          \ 'whitelist': ['python']
          \ })
  augroup END
endif
