" Look for specific filetype specific definitions in .vim/after/ftplugin and
" ./vim/ftplugin
"
set encoding=utf-8
"set t_Co=256

" Vundle and bundle configuration
set nocompatible " be iMproved
filetype off " required for Vundle

set shell=bash

if !empty($MY_RUBY_HOME)
 let g:ruby_path = join(split(glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".glob($MY_RUBY_HOME.'/lib/rubysite_ruby/*'),"\n"),',')
endif

set lazyredraw
"set ttyfast                               " Send more characters when redrawing the screen

let g:vundle_default_git_proto = 'git' 
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Ultimate auto-completion system for Vim
Bundle "ervandew/supertab"

" An extensible & universal comment vim-plugin that also handles embedded filetypes
Bundle "tomtom/tcomment_vim"

" MatchParen for HTML tags
Bundle "gregsexton/MatchTag"

" Provides sgml (xml, html, etc.) end tag completion
Bundle "ervandew/sgmlendtag"

" Functions for doing case-persistant substitutions
Bundle "vim-scripts/keepcase.vim"

" Motion through CamelCaseWords and underscore_notation.
Bundle "vim-scripts/camelcasemotion"

" quoting/parenthesizing made simple
Bundle "tpope/vim-surround"

" Easily search for, substitute, and abbreviate multiple variants of a word
Bundle "tpope/vim-abolish"

" A vim plugin that should simplify the transition between multiline and single-line code
Bundle "AndrewRadev/splitjoin.vim"

" Syntax checking hacks for vim
"Bundle "scrooloose/syntastic"

" Color coding of pairs of parenthesis, braces and brackets
Bundle "kien/rainbow_parentheses.vim"

" Git Gutter
Bundle 'airblade/vim-gitgutter'

" Git wrapper for vim
Bundle 'tpope/vim-fugitive'

" Vim Git runtime files
Bundle 'tpope/vim-git'

" Webapi neede for gist-vim
Bundle 'mattn/webapi-vim'

" Gist vim
Bundle 'mattn/gist-vim'

" Snippmate
Bundle 'msanders/snipmate.vim'

" Snippets for Snipmate
Bundle 'krisleech/snipmate-snippets'

" Vim plugin, provides insert mode auto-completion for quotes, parens, brackets, etc.
Bundle 'Raimondi/delimitMate'

" Ack
Bundle 'mileszs/ack.vim'

" Powerline
Bundle 'Lokaltog/vim-powerline'

" Vim script for text filtering and alignment
Bundle 'godlygeek/tabular'

" Fuzzy file, buffer, mru and tag finder
Bundle 'kien/ctrlp.vim'

" Vim/Ruby Configuration Files
Bundle 'vim-ruby/vim-ruby'

" Ruby on Rails power tools
Bundle 'tpope/vim-rails'

" Use rails.vim mappings but in projects which are not Rails projects
Bundle "git://github.com/tpope/vim-rake.git"

" Rvm support
Bundle 'tpope/vim-rvm'

" wisely add 'end' in Ruby, endfunction/endif/more in vim script, etc
Bundle 'tpope/vim-endwise'

" Add support for Gemfile/Gemfile.lock syntax highlighting and tag paths for bundled gems
Bundle "tpope/vim-bundler"

" Add support for rbenv including paths and tag support
"Bundle "tpope/vim-rbenv"

" JavaScript
Bundle 'pangloss/vim-javascript'

" Coffeescript
Bundle 'kchmck/vim-coffee-script'

" Jade plugin
Bundle 'digitaltoad/vim-jade'

" Jasmine Plugin for Vim
Bundle "claco/jasmine.vim"

" JSON Highlighting for Vim
Bundle "leshill/vim-json"

" Haml
Bundle 'tpope/vim-haml'

" Slim
Bundle 'slim-template/vim-slim'

" Markdown
Bundle 'tpope/vim-markdown'

" Pastie.org plugin
Bundle 'tpope/vim-pastie'

" HTML5 omnicomplete
Bundle 'othree/html5.vim'

" Emmet (formerly zencoding)
Bundle 'mattn/emmet-vim'

" Vim plugin for Handlebars
Bundle "nono/vim-handlebars"

" Add extra syntax highlighting for SCSS files
Bundle "cakebaker/scss-syntax.vim"

" Syntax highlighting for nginx configuration files
Bundle "mutewinter/nginx.vim"


" Load snippets from multiple directories
let g:snippets_dir = "~/.vim/bundle/snipmate/snippets/,~/.vim/snippets/"

" from http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
let mapleader = ","
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

"Automatically reload .vimrc if it changes
" via https://github.com/tbranyen/dotfiles/blob/master/.vimrc
autocmd! bufwritepost .vimrc source %

" Change tab stop
" via https://github.com/tbranyen/dotfiles/blob/master/.vimrc
map <silent> <leader>t2 :set tabstop=2 softtabstop=2 shiftwidth=2 expandtab<CR>
map <silent> <leader>t4 :set tabstop=4 softtabstop=4 shiftwidth=4 expandtab<CR>

" from http://items.sjbach.com/319/configuring-vim-right
" http://github.com/sjbach/env/blob/master/dotfiles/vimrc
set hidden
nnoremap ' `
nnoremap ` '
set history=1000
" Make file/command completion useful
set wildmenu
set wildmode=list:longest
set title
" Start scrolling when cursor is 3 lines from bottom of viewport
set scrolloff=3
filetype on
filetype plugin on
filetype indent on
" Display extra whitespace toggled by ,s
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>
" Another recipe to display extra whitespace from http://github.com/jferris/config_files/blob/master/vimrc
" set list listchars=tab:»·,trail:·

if has("gui_running")
  " DejaVu is needed for Kevin's MBP for MacVim
  "set gfn=DejaVu\ Sans\ Mono:h21
  " Monaco is for OA MBP
  set gfn=Monaco:h21
  "set guifont=Monaco:h21
  set co=107
  set columns=107
  set lines=30
endif

set vb

syntax on
set autoread
set autoindent                    "Preserve current indent on new lines
set ignorecase
set smartcase
set expandtab                     "Convert all tabs typed to spaces
set tabstop=2                     "Indentation levels every four columns
set shiftwidth=2                  "Indent/outdent by four columns
set shiftround                    "Indent/outdent to nearest tabstop
set showmatch
set ruler
set hlsearch
set incsearch
set backspace=indent,eol,start    "Make backspaces delete sensibly
set pastetoggle=<F7>
set smartindent
"set cindent
"#set textwidth=78                  "Wrap at this column
set switchbuf=split
 
" Map CTRL+J and CTRL+K to help navigate between split files
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-L> <C-W>l<C-W>_
set wmh=0 " allows splits to reduce to 1 line instead of 2

set matchpairs+=<:>               "Allow % to bounce between angles too

" Fx keymappings
map <F1> <Esc>
imap <F1> <Esc>
map! jj <Esc>
map <F3> :set number!<CR>
map <F4> :set wrap!<CR>
map <F5> :set list!<CR>

" Set viminfo to store last 50 edits
" and an autocmd to take me to the last line I was editing in a file
set viminfo='20,\"50
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

if has("gui_running")
  set cursorline "highlight current line
  set cursorcolumn "highlight current column
end
"set cursorline
hi Cursor ctermbg=LightCyan guibg=#cd4e00 guifg=bg gui=none
hi CursorColumn ctermbg=DarkGrey guibg=#dbdbdb gui=none
hi CursorLine ctermbg=LightGrey guibg=#dbdbdb gui=none
" Match parens and brackets with a subtle color
"hi MatchParen ctermbg=LightGrey guibg=#dbdbdb gui=none

" Make vim-gitgutter background color be white
highlight clear SignColumn




"runtime plugin/snippetEmu.vim
"imap <F12> <Plug>Jumper
" Redefine start and end tags for snippetEmu
let g:snip_start_tag = "<{"
let g:snip_end_tag = "}>"
let g:snip_set_textmate_cp = 1

" Use nmap, not nnoremap, since we do want to use an existing mapping
nmap ,,, viw,,,
vnoremap ,,, <Esc>:call TagSelection()<CR>

function! TagSelection()
  let tag = input("Tag name (include attributes)? ")

  if strlen(tag) == 0
      return
  endif

  " Save b register
  let saveB       = @b
  " <C-R> seems to automatically reindent the line for some filetypes
  " this will disable it until we have applied our changes
  let saveIndent  = &indentexpr
  let curl        = line(".")
  let curc        = col(".")
  let &indentexpr = ''

  " If the visual selection is over multiple lines, then place the
  " data between the tags on newlines:
  "    <tag>
  "    data
  "    </tag>
  let newline = ''
  if getline("'>") != getline("'<")
      let newline = "\n"
      let curl  = line("'>")
  endif

  " Strip off all but the first word in the tag for the end tag
  let @b = newline . substitute( tag, '^[ \t"]*\(\<\S*\>\).*', '<\/\1>\e', "" )
  let curc = curc + strlen(@b)
  exec "normal `>a\<C-R>b"

  let @b = substitute( tag, '^[ \t"]*\(\<.*\)', '<\1>\e', "" ) . newline
  let curc = curc + strlen(@b)
  exec "normal `<i\<C-R>b"

  " Now format the area
  exec "normal `<V'>j="

  " Restore b register
  let @b          = saveB
  let &indentexpr = saveIndent

  call cursor(curl, curc)
endfunction 

" Settings or text files. 
" turn on spelling when entering a text file: 
"autocmd BufRead,BufNewFile *.textile setlocal spell spelllang=en_us | set tw=78 
autocmd BufRead,BufNewFile *.textile setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us


" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" For Haml
au! BufRead,BufNewFile *.haml setfiletype haml

" vim-rails
" from http://github.com/kossnocorp/dotvim/blob/master/config/shortcuts.vim
map <Leader>rc :RScontroller<Space>
map <Leader>rm :RSmodel<Space>
map <Leader>rv :RSview<Space>
map <Leader>rh :RShelper<Space>

map <Leader>rj :RSjavascript<Space>
map <Leader>rst :RSstylesheet<Space>

map <Leader>rl :RSlayout<Space>

map <Leader>rs :RSspec<Space>

map <Leader>re :RSenvironment<Space>

map <Leader>ri :RSinitializer<Space>

map <Leader>ra :A<CR>
map <Leader>rr :R<CR>

map <Leader>a :Ack<Space>

" Make '<Leader>U' convert the current word to upper case.
nnoremap <Leader>U gUiw

" Do the same as above to convert the current word to upper case while still
" in insert mode
inoremap <C-u> <esc> gUiwea

map <Leader>y <C-y>

"emmet - Ctrl+e to expand css selectors
let g:user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_complete_tag = 1

let g:gist_browser_command = '/Applications/Safari.app/Contents/MacOS/Safari %URL%'

" Jump over closing ( " ' with l
silent! imap <unique> <buffer> <Leader>l <Plug>delimitMateS-Tab

set iskeyword=a-z,A-Z,48-57,_,-,>

" So Powerline works initially
set laststatus=2

" Surround a line with a tag
" via https://github.com/tbranyen/dotfiles/blob/master/.vimrc
map <leader>tw ysst

" Sync syntax highlighting if it breaks
"syntax sync fromstart
"syntax sync minlines=200
"autocmd BufEnter * :syntax sync fromstart
"noremap <Leader>ss <Esc>:syntax sync fromstart<CR>
"inoremap <Leader>ss <C-o>:syntax sync fromstart<CR>

set nocursorcolumn 

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['html'] = 'html, javascript, javascript-jquery'

"let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](node_modules)$',
  \ }

" Rails specific CtrlP mappings
map <leader>gs :CtrlP app/assets/stylesheets<cr>
map <leader>gj :CtrlP app/assets/javascripts<cr>
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gh :CtrlP app/helpers<cr>
map <leader>gt :CtrlP spec<cr>

  "\ 'file': '\v\.(exe|so|dll)$',
  "\ 'link': 'some_bad_symbolic_links',
