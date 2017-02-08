" This file contains a number of settings and macros collected by my from the
" internet thorughout few years on my usage of vim. I'm not the author of
" majority of them, however it's impossible for me to state the real authors.
" I hope the authors don't mind.

"turns on syntax
syntax on

set nocscopeverbose
set ruler
set smartindent

if !empty($TABSPACES)
    set expandtab
    execute "set shiftwidth=".$TABSPACES
    execute "set tabstop=".$TABSPACES
endif

"exit vim on ^C
noremap <C-c> :exit<CR>
inoremap <C-c> <ESC>:exit<CR>

"enable folding by markers
set foldmethod=marker

"erasing extra spaces
noremap .r :%s/[ \t]\+$//<CR>

"searching
set ignorecase
set smartcase
set incsearch
set hlsearch

"always show status line (with filename)
set laststatus=2

" ignore triangling whitespaces when comparing files
set diffopt+=iwhite

if &diff
set noro
endif

"change windows with C-Up/Dn
noremap [A <C-w>k
noremap [B <C-w>j
inoremap [A <Esc><C-w>k
inoremap [B <Esc><C-w>j

"toggle paste on .p
noremap .p :se invpaste<CR>

"disable search highlight on ./
noremap ./ :noh<CR>

"browse recently opened files
noremap .h :browse oldfiles<CR>

"browse recently opened files
noremap .s :setlocal spell spelllang=en_us<CR>

"color scheme
colorscheme elflord

"fix backspace
set backspace=2

"sets window title
set title

"man under cursor
"{{{
fun! ReadMan()
" Assign current word under cursor to a script variable:
let s:man_word = expand('<cword>')
" Read in the manpage for man_word (col -b is for formatting):
:exe ":!man -a " . s:man_word
endfun
" Map the K key to the ReadMan function:
noremap .m :call ReadMan()<CR>
"}}}

" Tell vim to remember certain things when we exit
" {{{
"  '20  :  marks will be remembered for up to 10 previously edited files
"  "1000:  will save up to 1000 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
se viminfo='10,\"1000,:20,%,n~/.viminfo
function! ResCur()
if line("'\"") <= line("$")
normal! g`"
return 1
endif
endfunction
augroup resCur
autocmd!
autocmd BufWinEnter * call ResCur()
augroup END
"}}}

"highlight extra spaces
"{{{
highlight ExtraWhitespace cterm=underline ctermfg=red
"ctermbg=DarkCyan guibg=DarkCyan
augroup WhitespaceMatch
" Remove ALL autocommands for the WhitespaceMatch group.
autocmd!
autocmd BufWinEnter * let w:whitespace_match_number =
\ matchadd('ExtraWhitespace', '\s\+$')
autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
if exists('w:whitespace_match_number')
call matchdelete(w:whitespace_match_number)
call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
else
" Something went wrong, try to be graceful.
let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
endif
endfunction
"}}}

"opening file:line
" {{{
" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_file_line') || (v:version < 700)
finish
endif
let g:loaded_file_line = 1

function! s:gotoline()
let file = bufname("%")

" :e command calls BufRead even though the file is a new one.
" As a workarround Jonas Pfenniger<jonas@pfenniger.name> added an
" AutoCmd BufRead, this will test if this file actually exists before
" searching for a file and line to goto.
if (filereadable(file))
return
endif

" Accept file:line:column: or file:line:column and file:line also
let names =  matchlist( file, '\(.\{-1,}\):\%(\(\d\+\)\%(:\(\d*\):\?\)\?\)\?$')

if empty(names)
return
endif

let file_name = names[1]
let line_num  = names[2] == ''? '0' : names[2]
let  col_num  = names[3] == ''? '0' : names[3]

if filereadable(file_name)
let l:bufn = bufnr("%")
exec ":bwipeout " l:bufn

exec "keepalt edit " . file_name
exec ":" . line_num
exec "normal! " . col_num . '|'
if foldlevel(line_num) > 0
exec "normal! zv"
endif


exec "normal! zz"
endif

endfunction

autocmd! BufNewFile *:* nested call s:gotoline()
autocmd! BufRead *:* nested call s:gotoline()
" -- opening file:line
" }}} 

"svn
"{{{
noremap .l :!svn blame <C-R>=expand("%:p") <CR> \| head -n <C-R>=line(".") <CR> \| tail -n 1 <CR>
noremap .ll :!svn blame <C-R>=expand("%:p") <CR>
vmap .l :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
"}}}

