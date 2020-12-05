"Plugins 

call plug#begin('~/.vim/plugged')
"Targets
Plug 'wellle/targets.vim'
"Color 
"
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ap/vim-css-color'

"Coc 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'tmhedberg/SimpylFold'
"Latex Compilation 

Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'


"Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
"let g:instant_markdown_mathjax = 1

"let g:md_pdf_viewer="zathura"

Plug 'skywind3000/asyncrun.vim'

" Disable folding by default
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1

Plug 'psliwka/vim-smoothie'

"Fuzzy Findder
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

" Git Based  
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'junegunn/gv.vim'
Plug 'sheerun/vim-polyglot'

"Themes
Plug 'Rigellute/rigel'
Plug 'morhetz/gruvbox'
Plug 'iCyMind/NeoSolarized'
Plug 'tomasiser/vim-code-dark'

"Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Tmux related plugin
Plug 'christoomey/vim-tmux-navigator'

" File Explorer 
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Development related plugins 
"Ctags 
"Plug 'ludovicchabant/vim-gutentags'

"Linting and error check 
Plug 'dense-analysis/ale'
Plug 'arcticicestudio/nord-vim'

" AutoCompletion for python
"Plug 'deoplete-plugins/deoplete-jedi'

" Distraction free mode for writing
Plug 'junegunn/goyo.vim'
" Snippets
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
Plug 'mbbill/undotree'
call plug#end()

" Open Nerd Tree by default
let g:deoplete#enable_at_startup = 1

"set Gdiff to open vertical split
set diffopt+=vertical
set number
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
syntax enable
set background=dark
set completeopt-=preview

set termguicolors
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox

"Latex Setting 
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

"Slip Window
nmap <leader>s :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Fuzzy file finder mapping 
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
" Zooom in and out of windows
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

"Snap 
"set foldmethod=syntax
"Coc 
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search worspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>k

" Custom Mapping 
nnoremap <Space> za
set relativenumber
nnoremap <C-p> :GFiles<CR>
autocmd FileType markdown colorscheme onedark
let mapleader = " "
set tabstop=2 
set shiftwidth=2

"set vim to copy by default to system clipboard
set clipboard=unnamedplus
"To prevent x to write to unmaedplus clipboard
nnoremap x "_x 
nnoremap X "_x 
"add commnet
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END
