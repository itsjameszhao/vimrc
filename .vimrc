" From missing semester at MIT
set nocompatible
syntax on
set shortmess+=I
set number
set laststatus=2
set backspace=indent,eol,start
" set hidden
set ignorecase
set smartcase
set incsearch
nmap Q <Nop>
set noerrorbells visualbell t_vb=
set mouse+=a
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
inoremap <Left> :echoe "Use h"<CR>
inoremap <Right> :echoe "Use l"<CR>
inoremap <Up> :echoe "Use k"<CR>
inoremap <Down> :echoe "Use j"<CR>

" Personal section
set clipboard=unnamed	
set foldmethod=indent
set foldlevel=99
let mapleader = ","
nnoremap <Leader>cp :let @* = expand('%:p')<CR>:echo 'Active file path copied'<CR>
nnoremap <Leader>cd: let @* = expand('%:p:h')<CR>:echo 'Active file directory path copied'<CR>
" Enable persistent file undo
set undofile
if !isdirectory("$HOME/.vim/undodir")
    call mkdir("$HOME/.vim/undodir", "p")
endif
set undodir=$HOME/.vim/undodir

" Highlight all search matches
set hlsearch
" Incremental search
set incsearch

" FZF file finding remappings
nnoremap <C-f> :Files<CR>
nnoremap <Leader>f :Rg<CR>

" Tell Vim to use Ripgrep instead of grep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Map ds to auto-generate a Python docstring
nnoremap <Leader>ds :PyDocstringFormat<CR>:echo 'Docstring generated'<CR>
nnoremap <Leader>c :let @* = ' '<CR>:let @" = ' '<CR>:let @0 = ' '<CR>
nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l

function! ToggleNERDTree()
	" Check if NERDTree is open
	if exists("g:NERDTree") && g:NERDTree.IsOpen()
		NERDTreeToggle
	else
		" Open NERDTree
		NERDTreeFind
	endif
endfunction


nnoremap <Space>n :call ToggleNERDTree()<CR>
nnoremap <Space>m :TMToggle<CR>

" Enable NERDTree to show hidden files
let NERDTreeShowHidden=1

nnoremap <Leader>d <Nop>
nnoremap <Leader>d :tab split \| YcmCompleter GoToDefinition<CR>

function! GoToGPTPersistentSessionBuffers()
	let l:current_buffer = bufnr('%')
	for bufnr in range(1, bufnr('$'))
		if buflisted(bufnr) && bufname(bufnr) =~ 'gpt-persistent-session'
			execute 'buffer' bufnr
			break
		endif
	endfor
endfunction

function! RemoveDuplicateTabs()
	let seen = {}
	let tabcount = tabpagenr('$')
	for i in range(tabcount, 1, -1)
		execute i . 'tabnext'
		let filepath = expand('%:p')
		if has_key(seen, filepath)
			execute 'tabclose'
		else
			let seen[filepath] = 1
		endif
	endfor
endfunction

nnoremap <Leader>rd :call RemoveDuplicateTabs()<CR>:echo 'Duplicate tabs removed'<CR>
	
" Auto close NERDTree when leaving a tab
autocmd TabLeave * if exists("t:NERDTreeBufName") | execute 'NERDTreeClose' | endif

" Keep the cursor always centered in the middle of the window
autocmd BufEnter, WinEnter * set scrolloff=999

" Save session automatically when exiting Vim
autocmd VimLeave * mksession! ~/session.vim

call plug#begin()

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'
Plug 'pixelneo/vim-python-docstring'
" Plug 'davidhalter/jedi-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'CoderCookE/vim-chatgpt'
Plug 'python-mode/python-mode', {'for': 'python', 'branch': 'develop'}
Plug 'ajmwagar/vim-deus'
Plug 'ycm-core/YouCompleteMe', {'do': './install.py'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'kien/tabman.vim'
Plug 'heavenshell/vim-pydocstring', {'do': 'make install', 'for': 'python'}
Plug 'easymotion/vim-easymotion'
Plug 'github/copilot.vim'

call plug#end()
colors deus
syntax on
" Increase vim-plug timeout for YouCompleteMe install
let g:plug_timeout = 300

" Use specific linters
let g:ale_linters = {
\       'python': ['flake8', 'mypy', 'pylint'],
\}

"Use most suggested fixers
let g:ale_fix_on_save = 1
let g:ale_fixers={
\       'python': ['add_blank_lines_for_python_control_statements', 'autoflake', 'autoimport', 'autopep8', 'black', 'isort', 'pycln', 'remove_trailing_lines', 'ruff', 'ruff_format', 'trim_whitespace', 'yapf'],
\}

" Configure default host program for Python
let g:python_host_prog = '~/.venv/uiai/bin/python3'

"Configure default host program for Python

" Lint while typing
let g:ale_lint_on_text_changed = "always"

" Show warnings and errors in location list
let g:ale_set_loclist = 1

" Enable auto definition, show documentation, and autocompletion with jedi-vim
let g:jedi#auto_vim_configuration = 1

" Enable support for ChatGPT with Vim
let g:chat_gpt_max_tokens=2000
let g:chat_gpt_model='gpt-4-0125-preview'
let g:chat_gpt_session_mode=1
let g:chat_gpt_temperature=0.1
let g:chat_gpt_lang='English'
let g:chat_gpt_split_direction='vertical'

" Enable Pymode rope support
let g:pymode = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>r'
