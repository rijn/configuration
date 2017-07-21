set nocompatible

filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Fix ycm bug
let g:ycm_path_to_python_interpreter="/usr/local/bin/python"

" ===VUNDLE===
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Xuyuanp/nerdtree-git-plugin'

Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'

Plugin 'YankRing.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ervandew/supertab'
Plugin 'honza/vim-snippets'
Plugin 'kshenoy/vim-signature'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/syntastic'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'vim-scripts/matchit.zip'
Plugin 'terryma/vim-expand-region'
" Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rizzatti/dash.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'pangloss/vim-javascript'

Plugin 'Valloric/YouCompleteMe'
Plugin 'Chiel92/vim-autoformat'
Plugin 'rhysd/vim-clang-format'

call vundle#end()            " required
" ===END of VUNDLE===

filetype plugin indent on    " required

syntax on
syntax enable

"set t_Co=256

set background=dark
colorscheme solarized

" set guifont=Monaco\ 11
set guifont=Input\ Mono:h11

set relativenumber
set number
set ff=unix
set cindent
set laststatus=2
set shiftwidth=4
set sts=4
set tabstop=4
set expandtab
set backspace=indent,eol,start
set encoding=utf-8
set colorcolumn=80,100,120
set cursorline
set cursorcolumn
set incsearch
set hlsearch
set nowrap
set ruler
set title

" Do not expand tabs in assembly file.  Make them 8 chars wide.
au BufRead,BufNewFile *.s set noexpandtab
au BufRead,BufNewFile *.s set shiftwidth=8
au BufRead,BufNewFile *.s set tabstop=8

" For switching between many opened file by using ctrl+l or ctrl+h
map <C-J> :next <CR>
map <C-K> :prev <CR>

"""""Airline""""
if has('gui_running')
    let g:airline_theme = "solarized"
else
    let g:airline_theme = "molokai"
endif
let g:airline_powerline_fonts = 1

"""""YankRing""""
let g:yankring_history_dir = '~/webroot'

""""""YCM""""
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_semantic_triggers = {}

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-n>"
let g:UltiSnipsJumpBackwardTrigger = "<C-p>"

"""""Syntastic""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height= 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_pylint_post_args = "--disable=W1234"
let g:syntastic_python_checkers = ['pylint']

"""""FORCE UltiSnip to USE PY2""""
let g:UltiSnipsUsePythonVersion = 2
"""""Snippets variables""""
let g:snips_author = 'Rijn Bian'
let g:author = 'Rijn Bian'
let g:snips_email = 'bxbian951122@gmail.com'
let g:email = 'bxbian951122@gmail.com'
let g:snips_github = 'https://github.com/rijn'
let g:github = 'https://github.com/rijn'

"""""Tagbar"""""
nmap <Leader>tl :TagbarToggle<CR>
let tagbar_width=32

"""""Indent Guide"""""
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
:nmap <silent> <Leader>i <Plug>IndentGuidesToggle

"""""Code Folding""""
"za toggle current folding
"zM close all the folding
"zR open all the folding
set foldmethod=indent
set foldmethod=syntax
set nofoldenable

""""vim-signature""""
let g:SignatureMap = {
    \ 'Leader'             :  "m",
    \ 'PlaceNextMark'      :  "m,",
    \ 'ToggleMarkAtLine'   :  "m.",
    \ 'PurgeMarksAtLine'   :  "m-",
    \ 'DeleteMark'         :  "dm",
    \ 'PurgeMarks'         :  "mda",
    \ 'PurgeMarkers'       :  "m<BS>",
    \ 'GotoNextLineAlpha'  :  "']",
    \ 'GotoPrevLineAlpha'  :  "'[",
    \ 'GotoNextSpotAlpha'  :  "`]",
    \ 'GotoPrevSpotAlpha'  :  "`[",
    \ 'GotoNextLineByPos'  :  "]'",
    \ 'GotoPrevLineByPos'  :  "['",
    \ 'GotoNextSpotByPos'  :  "mn",
    \ 'GotoPrevSpotByPos'  :  "mp",
    \ 'GotoNextMarker'     :  "[+",
    \ 'GotoPrevMarker'     :  "[-",
    \ 'GotoNextMarkerAny'  :  "]=",
    \ 'GotoPrevMarkerAny'  :  "[=",
    \ 'ListLocalMarks'     :  "ms",
    \ 'ListLocalMarkers'   :  "m?"
    \ }

""""Habit Breaking"""""
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

""""Remove Trailing Whitespace""""
nnoremap <Leader>rtw :%s/\s\+$//e<CR>

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

nmap <F8> :TagbarToggle<CR>
nmap <F9> :YcmDiags<CR>

noremap <F3> :ClangFormat<CR>

" Clang format
let g:clang_format#style_options = {
    \ "BasedOnStyle": "Google",
    \ "SpacesInParentheses": "true",
    \ "IndentWidth": 4,
    \ "AlignConsecutiveAssignments": "true",
    \ "AlignConsecutiveDeclarations": "true",
    \ "AlignOperands": "true",
    \ "AllowShortFunctionsOnASingleLine": "None",
    \ "PointerAlignment": "Right",
    \ "DerivePointerAlignment": "true",
    \ "AlignAfterOpenBracket": "Align"}

nmap <F2> :!svn ci -m "commit from vim"<CR>

" Git Gutter

let g:gitgutter_realtime = 2000
let g:gitgutter_eager = 2000

" vim-javascript

let g:javascript_plugin_jsdoc = 1

