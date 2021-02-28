" CoC extensions
"let g:coc_global_extensions = [
"  \ 'coc-pairs',
"  \ 'coc-emmet',
"  \ 'coc-html',
"  \ 'coc-css',
"  \ 'coc-highlight',
"  \ 'coc-lists',
"  \ 'coc-tsserver',
"  \ 'coc-prettier',
"  \ 'coc-syntax',
"  \ ]

"
" CoC settings
"

let g:livepreview_previewer = 'zathura'
" Prevent delays
set updatetime=300

" Text edit may fail if hidden is not set
set hidden

" Don't pass messages to completion menu
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() #"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"
" vim-latex-live-preview
"

"
" My own settings
"

" text width and show commands
set tw=80
set showcmd

" enable wildmenu
set path+=**
set wildmode=full

" enable loading local .exrc
set exrc

" set tabs to 4 spaces
set shiftwidth=4
" tabstop
set ts=4
" autoindent
set ai
" smartindent
set si

" wrapped lines show one space under beginning
set breakindent
set breakindentopt=shift:2

" whitespace visualisation (enable with :set list)
set listchars+=space:·
set listchars+=tab:│\ 
"set list

" enable wrapped line navigation
noremap <silent> <expr> j (v:count == 0 ? "gj" : "j")
noremap <silent> <expr> k (v:count == 0 ? "gk" : "k")

" show line number on current line, and relative to current line on other lines,
" if not in a ssh session
set nu
set rnu

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

" copy file to primary system clipboard
noremap <F12> ggVG"+y

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

"
" plugin configs
"
" prettier
"command! -nargs=0 Prettier :CocCommand prettier.formatFile
"vmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

" augroups
aug indents
	autocmd!
	autocmd FileType sass,scss,css,html,javascript,vue,conf,nix setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType rust setlocal sts=4 sw=4 et
aug END
