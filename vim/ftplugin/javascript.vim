" Prettier integration via Neoformat
autocmd BufWritePre *.js Neoformat

" check for node_modules version of Prettier and fallback to global
let s:formatprg = findfile('node_modules/.bin/prettier', '.;')
if !executable(s:formatprg)
    let s:formatprg = exepath('prettier')
endif
let &l:formatprg = s:formatprg . ' --stdin'

" Use formatprg when available
let g:neoformat_try_formatprg = 1
