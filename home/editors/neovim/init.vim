" Prevent delays
set updatetime=300
" Text edit may fail if hidden is not set
set hidden
set shortmess+=c
set signcolumn=number

" text width and show commands
set tw=80
set showcmd

" enable wildmenu
set path+=**
set wildmode=full

" enable loading local .exrc
set exrc

set nu

" set tabs to 4 spaces
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent

" wrapped lines show one space under beginning
set breakindent
set breakindentopt=shift:2

" whitespace visualisation (enable with :set list)
set listchars+=space:·
set listchars+=tab:│\ 

" enable wrapped line navigation
noremap <silent> <expr> j (v:count == 0 ? "gj" : "j")
noremap <silent> <expr> k (v:count == 0 ? "gk" : "k")

" set variable extension
let e=expand('%:e')

" set F9 behaviour for compiling different languages
:if e == "cpp" || e == 'c'
:	nnoremap <F9> :make %:r<CR>
:elseif e == "java"
:	nnoremap <F9> :terminal javac %:t<CR>i
:elseif e == "rs"
:	nnoremap <F9> :terminal cargo build<CR>i
:endif

" set F10 behaviour for running different languages
:if e == "java"
:	nnoremap <F10> :terminal java %:r<CR>i
:elseif e == "py"
:	nnoremap <F10> :terminal python %:r<CR>i
:elseif e == "rs"
:	nnoremap <F10> :terminal cargo run<CR>i
:else
:	nnoremap <F10> :terminal ./%:r<CR>i
:endif

" copy selection to primary system clipboard
noremap <F12> "+y

" enable netrw
filetype plugin on

" statusline
set statusline+=\ %n│
set statusline+=\ %f
set statusline+=\ %([%M%R%H]%)
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %p%%
set statusline+=\ %l:%v│%L
set statusline+=\ 

" augroups
aug indents
	autocmd!
	autocmd FileType sass,scss,css,html,javascript,vue,conf setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType rust setlocal sts=4 sw=4 et
aug END
