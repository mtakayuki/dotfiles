" Required for operations modifying multiple buffers like rename.
set hidden

let s:pyls_path = fnamemodify(g:python_host_prog, ':h') . '/'. 'pyls'
let g:LanguageClient_serverCommands = {
      \ 'python': [expand(s:pyls_path)],
      \ 'go': ['gopls'],
      \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

augroup LspGo
  autocmd!
  autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting()
augroup END
