" Look for specific filetype specific definitions in .vim/after/ftplugin and
" ./vim/ftplugin

" from http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
let mapleader = ","
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

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

syntax on
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
 
" Map CTRL+J and CTRL+K to help navigate between split files
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-L> <C-W>l<C-W>_
set wmh=0 " allows splits to reduce to 1 line instead of 2

set matchpairs+=<:>               "Allow % to bounce between angles too

" Fx keymappings
map <F3> :set number!<CR>
map <F4> :set wrap!<CR>
map <F5> :set list!<CR>

" Perltidy stuff
" run perltidy on entire file
map ti :%!perltidy 
" run perltidy on highlighted text/lines in visual mode
vmap vti :!perltidy<CR>
" run current line through perltidy
map mt :.!perltidy

" Pythontidy stuff
" run pythontidy on entire file
map pti :%!PythonTidy.py
" run pythontidy on highlighted text/lines in visual mode
vmap pvti :!PythonTidy.py<CR>

" Set viminfo to store last 50 edits
" and an autocmd to take me to the last line I was editing in a file
set viminfo='20,\"50
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Turn on Omni complete
"autocmd FileType css set omnifunc=syntaxcomplete#Complete
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType perl set omnifunc=syntaxcomplete#Complete
"
" Navigate the omni complete menu with j and k
"inoremap <expr> j     pumvisible()?"\<C-N>":"j"
"inoremap <expr> k     pumvisible()?"\<C-P>":"k"

if has("gui_running")
  set cursorline "highlight current line
  set cursorcolumn "highlight current column
end
"set cursorline
hi Cursor ctermbg=LightCyan guibg=#cd4e00 guifg=bg gui=none
hi CursorColumn ctermbg=DarkGrey guibg=#dbdbdb gui=none
hi CursorLine ctermbg=LightGrey guibg=#dbdbdb gui=none
" Match parens and brackets with a subtle color
hi MatchParen ctermbg=LightGrey guibg=#dbdbdb gui=none



" TagList plugin
"nnoremap <silent> <F12> :TlistOpen<CR>
" Close the taglist window when a function is selected
"let TList_Close_On_Select = 1
"let Tlist_Compact_Format = 1
" If not set, only processes newly opened files if taglist is open
"let Tlist_Process_File_Always = 1
"let Tlist_Sort_Type = "name"



autocmd FileType perl call PerlProgSettings()
function! PerlProgSettings()
  set tabstop=4                     "Indentation levels every four columns
  set shiftwidth=4                  "Indent/outdent by four columns
  set cindent
  " perl comments start with #, anywhere on the line
  set comments=:#
  set cinkeys-=0#
  " If you want complex things like '@{${"foo"}}' to be parsed:
  let g:perl_extended_vars = 1
  let g:perl_sync_dist = 100
  " See ':help syntax'
  "let g:perl_fold = 1
  "set foldlevelstart=1
  " handy abbreviations
  iab udd use Data::Dumper;
  iab cst $c->stash->{}
  iab cre $c->response->
  set makeprg=perl\ -c\ %
  nmap <Leader>pf :!perldoc -f <cword><CR>
  nmap <Leader>pd :e `perldoc -ml <cword>`<CR>
  " from http://www.vim.org/tips/tip.php?tip_id=855
  "inoremap {<cr> {<cr>}<esc>O<tab>
  inoremap {<cr> {<cr>}<esc>O
  " Do the same for parentheses
  inoremap ( ()<esc>i
endfunction

" Editing files with comma-separated values has never been so fun!
" All this next stanza does is allow one to use F9 and F10 to highlight
" the previous and next columns, respectively. This makes editing CSV
" in Vim much more convenient than visually matching up columns.
autocmd BufNewFile,Bufread *csv call CSVSettings()
function! CSVSettings()
  let b:current_csv_col = 0
  " inspired by Vim tip #667
  function! CSV_Highlight(x)
    if b:current_csv_col == 0
      match Keyword /^[^,]*,/
    else
      execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
    endif
    execute 'normal ^'.a:x.'f,'
  endfunction

  " start by highlighting something, probably the first column
  call CSV_Highlight(b:current_csv_col)

  function! CSV_HighlightNextCol()
    let b:current_csv_col = b:current_csv_col + 1
    call CSV_Highlight(b:current_csv_col)
  endfunction
  function! CSV_HighlightPrevCol()
    if b:current_csv_col > 0
      let b:current_csv_col = b:current_csv_col - 1
    endif
    call CSV_Highlight(b:current_csv_col)
  endfunction
  map <F8> :call CSV_HighlightPrevCol()<CR>
  map <F9> :call CSV_HighlightNextCol()<CR>
endfunction




"Inserting these abbreviations inserts the corresponding Perl statement...
"iab phbp  #! /usr/bin/perl -w      
"iab pdbg  use Data::Dumper 'Dumper';warn Dumper [];hi
"iab pbmk  use Benchmark qw( cmpthese );cmpthese -10, {};O     
"iab pusc  use Smart::Comments;### 
"iab putm  use Test::More qw( no_plan );
"iab papp  :r ~/.code_templates/perl_application.pl
"iab pmod  :r ~/.code_templates/perl_module.pm

" Mason abbreviations
iab ah Amcity::HMN;
iab ahu Amcity::HMN::User;
iab ahf Amcity::HMN::Fable;
iab ahr Amcity::HMN::Ride;
iab aht Amcity::HMN::Tag;
iab ahc Amcity::HMN::Classified;
iab ahd Amcity::HMN::Dealer;
" in Amcity::HMN::Apache::*
iab ahasa Amcity::HMN::Apache::SearchAds;
iab ahau Amcity::HMN::Apache::Util;
iab ahaua Amcity::HMN::Apache::UserAccount;

" HTML abbreviations
iab hhref <a href=""></a>
iab hbr <br/>
iab hdiv <div></div>
iab hdivb <div>
iab hdive </div>
iab hspan <span></span>
iab htbl <table></table>
iab htr <tr></tr>
iab htd <td></td>

autocmd BufNewFile *.{pl,pm} call <SID>insert_header()
autocmd BufNewFile,BufRead *.{html} set syntax=mason

" Define a function that can tell me if a file is executable
function! FileExecutable (fname)
	execute "silent! ! test -x" a:fname
	return v:shell_error
endfunction

"Automatically make Perl and Shell scripts executable if they aren't already
"au BufWritePost *.sh,*.pl,*.cgi if FileExecutable("%:p") | :!chmod a+x % ^@ endif


function! s:insert_header()
execute "normal i#!/usr/bin/perl"
execute "normal o"
execute "normal ouse warnings;"
execute "normal ouse strict;"
execute "normal o#Written by Kevin at " . strftime("%c")
endfunction

" , #perl # comments
map ,# :s/^/#/<CR>
  
" ,/ C/C++/C#/Java // comments
map ,/ :s/^/\/\//<CR>
  
" ,< HTML comment
map ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
  
" c++ java style comments
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>

" ,cc clear the comments
map ,cc :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR><Esc>:nohlsearch<CR>

"runtime plugin/snippetEmu.vim
"imap <F12> <Plug>Jumper
" Redefine start and end tags for snippetEmu
let g:snip_start_tag = "<{"
let g:snip_end_tag = "}>"
let g:snip_set_textmate_cp = 1


" Set it so that xml.vim uses XHTML
"let g:xml_use_xhtml = 1
" Define emptyTags for xml.vim
"let g:emptyTags='^\(img\|input\|param\|frame\|br\|hr\|meta\|link\|base\|area\|TMPL_VAR\|TMPL_INCLUDE\|%\|-\|>\)$'

let g:do_xhtml_mappings = 1
let g:no_html_tab_mapping = 'yes'

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings for quick and smart brackets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"execute "source ~/.vim/scripts/brackets3.vim"

"inoremap <Leader>or ()<esc>:call     BC_addBracket(")")<cr>i
"inoremap <Leader>os []<esc>:call     BC_addBracket("]")<cr>i
"inoremap <Leader>oa <><esc>:call     BC_addBracket(">")<cr>i
"inoremap <Leader>oq ''<esc>:call     BC_addBracket("'")<cr>i
"inoremap <Leader>oqq ""<esc>:call    BC_addBracket('"')<cr>i
"inoremap <Leader>oc {<cr>}<esc>:call BC_addBracket("}")<cr>ko<cr>
" jump out of parenthesis
"inoremap <Leader>cb <esc>:call search(BC_getBracket(), "w")<cr>a
" clear out the stack and start over
"inoremap <Leader>cbbb <esc>:call BC_clearBracket()<cr>a
"nnoremap <Leader>cbbb :call BC_clearBracket()<CR>
" show whats currently in the stack 
"inoremap <Leader>showb <esc>:call BC_showBracket()<cr>a
"nnoremap <Leader>showb :call BC_showBracket()<CR>
" Visually select the current word under the cursor
"nnoremap <Leader>vw ebve

"autocmd FileType html,erb source ~/.vim/scripts/sparkup.vim
source ~/.vim/scripts/sparkup.vim


" from http://biodegradablegeek.com/vim/
inoremap '      ''<Left>
inoremap ''     '

inoremap "      ""<Left>
inoremap ""     "

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O<SPACE><SPACE>
inoremap {{     {
inoremap {}     {}

inoremap (      ()<LEFT>
inoremap (<CR>  (<CR>)<Esc>O<TAB>
inoremap ((     (
inoremap ()     ()

inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O<TAB>
inoremap [[     [
inoremap []     []


" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" For Haml
au! BufRead,BufNewFile *.haml setfiletype haml
