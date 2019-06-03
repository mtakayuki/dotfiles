" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ 'go': ['gopls'],
      \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

augroup LspGo
  autocmd!
  autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting()
augroup END
