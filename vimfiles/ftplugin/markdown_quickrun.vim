" markdown
let g:quickrun_config = {
\ 'markdown/normal' : {
\   'outputter' : 'error',
\   'outputter/error/error' : 'message',
\   'command' : 'mkdpreview',
\   'srcfile' : expand("%"),
\   'cmdopt' : '',
\   'exec': '%c %o %s',
\   },
\
\ 'markdown/visual' : {
\   'outputter' : 'error',
\   'outputter/error/error' : 'message',
\   'command' : 'mkdpreview',
\   'cmdopt' : '-p',
\   'exec': '%c %o %s',
\   },
\}

let g:quickrun_config['markdown'] = {
\ 'outputter' : 'error',
\ 'outputter/error/error' : 'message',
\ 'command' : 'mkdpreview',
\ 'cmdopt' : '-s -p',
\ 'exec': '%c %o %s',
\}

let g:quickrun_config['mkd'] = {
\ 'outputter' : 'error',
\ 'outputter/error/error' : 'message',
\ 'command' : 'mkdpreview',
\ 'cmdopt' : '-s -p',
\ 'exec': '%c %o %s',
\}

" QuickRun and view compile result quickly
nnoremap <silent> <F5> :QuickRun<CR>
vnoremap <silent> <F5> :QuickRun<CR>

autocmd BufWritePost,FileWritePost *.md QuickRun -type markdown/normal
