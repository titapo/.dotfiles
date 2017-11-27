set nocompatible              " be iMproved, required
filetype off                  " required

" Vundle plugins {
    " set the runtime path to include Vundle and initialize {
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'gmarik/Vundle.vim'
    Plugin 'junegunn/fzf.vim'
    " Plugin 'klen/python-mode'
    Plugin 'peterhoeg/vim-qml'
    Plugin 'scrooloose/nerdtree'
    Plugin 'tpope/vim-fugitive'
    Plugin 'vim-scripts/DrawIt'
    Plugin 'mgedmin/chelper.vim' " just a helper for legacy c
    " Plugin 'Valloric/YouCompleteMe'
    call vundle#end()            " required
    filetype plugin indent on    " required
"}

" color {
    set background=dark
"}

" settings around statusline {

    set cmdheight=2

    set laststatus=2
    " set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=0x\%04B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]


    command! LegacyMode set statusline=%<%f\ %h%m%r\ %{CTagInStatusLine()}%*%=%-14.(%l,%c%V%)\ %P
    set wildmenu
"}

" searching {
    set incsearch
"}

" mappings {
    " disable arrows {
    nmap <up> <nop>
    nmap <down> <nop>
    nmap <left> <nop>
    nmap <right> <nop>

    function! EnableArrowKeys()
        nunmap <up>
        nunmap <down>
        nunmap <left>
        nunmap <right>
        echom 'Arrow keys are enabled in normal mode!'
    endfunction

    nnoremap <leader>aa :call EnableArrowKeys()<CR>
    "}

    nnoremap <leader>ev :vsplit $MYVIMRC<CR>
    nnoremap <leader>sv :source $MYVIMRC<CR>
    nnoremap <silent> <leader>n :NERDTreeToggle<CR>
    nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>gg :g//

    vnoremap . :normal .
    nnoremap <F2> :Ggrep <C-R>/<CR><CR>:cl<CR>
    vnoremap <F2> y/<C-r>"<CR>:Ggrep <C-R>/<CR><CR>:cl<CR>
    nnoremap <F4> :call SwitchBetweenHeaderAndSource()<CR>
    map <F5> <ESC>:setlocal spell! spelllang=en_us<RETURN><ESC>
    map <F10> :set paste<CR>
    map <F11> :set nopaste<CR>
    imap <F10> <C-O>:set paste<CR>
    imap <F11> <nop>
    set pastetoggle=<F11>

    " Custom commands
    " temporary diff review
    map <F8> :bd<CR> I# <Esc>j
    map <F9> :botright vertical wincmd f<CR> :Git! diff master..HEAD -- %<CR>

    " pressing * in visual mode will searches for selection (uses default register) FIXME
    vnoremap * y/<C-r>"<Enter>


"}

set autowriteall
set modeline modelines=2
set number

set textwidth=120
highlight LineTooLong cterm=bold ctermbg=red guibg=LightYellow

set scrolloff=4

set tabstop=2
set shiftwidth=2
set expandtab

function! GetFirstExpandedFilePath(extensionPattern)
    return get(split(globpath("%:h", expand("%:t:r") . a:extensionPattern, 1)), 0, "")
endfun

function! GetFilepathToSwitch()
    if match(expand("%"), '\.c') > 0
        return GetFirstExpandedFilePath("*.h*")
    elseif match(expand("%"), '\.h') > 0
        return GetFirstExpandedFilePath("*.c*")
    else
        return ""
    endif
endfun

function! SwitchBetweenHeaderAndSource()
    let path = GetFilepathToSwitch()
    if strlen(path) < 1
        echo "No file found to switch!"
        return
    endif

    execute "edit" path
endfun

" YouCompleteMe {
    let g:ycm_confirm_extra_conf = 0
"}

" NERDTree {
    let g:nerdtree_tabs_open_on_console_startup = 1
"}

" fzf.vim {
    nnoremap <F6> :Files<CR>
    nnoremap <leader>f :Files<CR>
    nnoremap <leader>b :Buffers<CR>
" }

" " Python mode {
" 
"     " turn off folding:
"     let g:pymode_folding = 0
" 
"     " auto-virtualenv detection:
"     let g:pymode_virtualenv = 1
" 
"     let g:pymode_options_max_line_length = 142
" 
"     " Web2py automagically imported stuffs can be added here:
"     let g:pymode_lint_options_pyflakes = {'builtins': 'T,request,db,response,current,XML,HTML,TABLE,TD,TR'}
"     let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
"     let g:pymode_lint_options_pylint = {'max-line-length': g:pymode_options_max_line_length}
" 
"     " Ignored error codes:
"     let g:pymode_lint_ignore=["E251", "E302", "E401"]
" 
"     " run pymode on filewrite:
"     au BufWriteCmd *.py write || :PymodeLint
" "}

" Also switch on highlighting the last used search pattern.
if has("syntax") && (&t_Co > 2 || has("gui_running"))
    syntax on
    set hlsearch
endif

" projecting (experimental) {
"    source ~/proj.vim
"}

" highlight current line for viewing log files
command! Log set cursorline | highlight CursorLine ctermbg=NONE cterm=NONE ctermfg=blue

command! CountMatches :%s///gn
