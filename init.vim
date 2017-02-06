"#######################
" key config
"#######################

let mapleader = ','
let maplocalleader = ','
noremap \ ,

" .vimrcの編集を簡単にする
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>

" <Leader><Leader>で変更があれば保存
noremap <Leader><Leader> :up<CR>

" インサートモードのjjをEscにバインド
inoremap <silent> jj <ESC>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" :と;入れ替え
nnoremap ; :
nnoremap : ;

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" quickrunで開いたバッファを閉じる
nnoremap <Space>o :only<CR>

" カーソル位置の単語をyankする
nnoremap vv vawy

" 行末までのヤンク
nnoremap Y y$

"入力モードで削除
inoremap <C-d> <Del>
inoremap <C-h> <BackSpace>

"コマンドモードでemacsチックに
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>

"コマンドモードの履歴
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"コマンドモードでペースト
cnoremap <C-y> <C-r>"

"#######################
" Variables
"#######################
let s:config_root = expand('~/.vim')

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux = !s:is_windows && !s:is_cygwin && !s:is_darwin

if s:is_windows
  " use english interface
  language message en
  " exchange path separator
  set shellslash
else
  " use english interface
  language message C
endif

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END


"#######################
" 表示系
"#######################
set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
set matchtime=1 "showmatchのカーソルが飛ぶ時間を0.1秒の何倍か
set matchpairs& matchpairs+=<:> " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start " バックスペースでなんでも消せるようにする
set laststatus=2 "ステータスラインを常に表示
set list "タブ文字、行末など不可視文字を表示する
"listで表示される文字のフォーマットを指定する
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% 
set splitright "新しいウィンドウを右に開く
set visualbell "エラー時にビープ音の代わりに画面フラッシュを使う
set t_vb= "そして画面フラッシュも無効化
set clipboard+=unnamed "OSのクリップボードを使用する
set clipboard=unnamed "ヤンクした文字は、システムのクリップボードに入れる
set cursorline " カーソル行をハイライト
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
" highlight CursorLine ctermbg=black guibg=black

" iTerm2で、カーソルの形状を変更
if $TERM_PROGRAM == 'iTerm.app'
  " different cursors for insert vs normal mode
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\e]50;CursorShape=1\x7"
    let &t_EI = "\e]50;CursorShape=0\x7"
  endif
endif
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"全角スペース
highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
au BufRead,BufNew * match JpSpace /　/

" texのconcealを無効化
let g:tex_conceal=''
"#######################
" プログラミングヘルプ系
"#######################
syntax on "カラー表示
set smartindent "オートインデント
set shiftround  " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase   " 補完時に大文字小文字を区別しない
" tab関連
set smarttab " 'shiftwidth' の数だけインデントする
set expandtab "タブの代わりに空白文字挿入
"set ts=4 sw=4 sts=0 "タブは半角4文字分のスペース
" ファイルを開いた際に、前回終了時の行で起動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0
if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  augroup FileTypeSetLocal
    autocmd!
    autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
    autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType go         setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript setlocal sw=4 sts=4 ts=8 et
    autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType php        setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType python     setlocal sw=4 sts=4 ts=8 et
    autocmd FileType kivy       setlocal sw=4 sts=4 ts=8 et
    autocmd FileType r          setlocal sw=2 sts=2 ts=2 et
    autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType stan       setlocal sw=2 sts=2 ts=8 et
    autocmd FileType sql        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
    autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
    autocmd FileType jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000
  augroup END
endif

"#######################
" 検索系
"#######################
set ignorecase "検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set noincsearch "検索文字列入力時に順次対象文字列にヒットさせない
set nohlsearch "検索結果文字列の非ハイライト表示

"#######################
" その他
"#######################
if s:is_windows
  set backupdir=C:/Temp
  set directory=C:/Temp
elseif isdirectory($HOME . '/tmp')
  "set nobackup " バックアップを取らない
  " バックアップディレクトリを変更
  set backupdir=$HOME/tmp
  "set noswapfile " スワップファイルを作らない
  " スワップファイルディレクトリを変更
  set directory=$HOME/tmp
  "set noundofile " Undo ファイルを作らない
  " Undo ファイルディレクトリを変更
  set undodir=$HOME/tmp
  set undofile " Undo ファイルを作る。
endif

" Set python paths
let g:python_host_prog = expand('$HOME') . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = expand('$HOME') . '/.pyenv/versions/neovim3/bin/python'

"#######################
" dein
"#######################
"let s:dein_root = s:config_root . '/dein'
"let s:deinvim_root = s:dein_root . '/repos/github.com/Shougo/dein.vim'
let s:dein_plugin_dir = expand('~/.cache/dein')
let s:dein_cache_dir = s:dein_plugin_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
  set nocompatible
endif

" set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
" set runtimepath+=s:dein_cache_dir

if dein#load_state(s:dein_plugin_dir)

  call dein#begin(s:dein_plugin_dir)

  " Basic
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

  " Unite
  call dein#add('Shougo/denite.nvim')
  if dein#tap('denite.nvim')
    nnoremap <silent> <C-k><C-f> :<C-u>Denite file_rec<CR>
    nnoremap <silent> <C-k><C-g> :<C-u>Denite grep<CR>
    nnoremap <silent> <C-k><C-l> :<C-u>Denite line<CR>
    nnoremap <silent> <C-k><C-u> :<C-u>Denite file_mru<CR>
    nnoremap <silent> <C-k><C-y> :<C-u>Denite neoyank<CR>
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])
  endif
  call dein#add('Shougo/neoyank.vim')
  call dein#add('Shougo/neomru.vim')

  " Style / Display
  call dein#add('cocopon/iceberg.vim')

  " ステータスラインをカスタマイズ
  call dein#add('itchyny/lightline.vim')
  let g:lightline = {
    \ 'colorscheme': 'landscape',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ]
    \   }
    \ }


  " インデント可視化
  call dein#add('nathanaelkane/vim-indent-guides')
    if dein#tap('vim-indent-guides')
      let g:indent_guides_enable_on_vim_startup = 1
      let g:indent_guides_guide_size = 1
      let g:indent_guides_auto_colors = 0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
      let g:indent_guides_start_level= 2
    endif

  "" Programming
  "  call dein#add('thinca/vim-quickrun')
  call dein#add('thinca/vim-quickrun', {
    \ 'depends' : 'shabadou.vim',
    \ 'on_map': [['nxo', '<Plug>(quickrun)']],
    \ 'lazy' : 1,
    \ })
  "     call dein#add('osyo-manga/shabadou.vim')
  call dein#add('osyo-manga/shabadou.vim', {
    \ 'lazy' : 1,
    \ })
  nmap <Leader>q <Plug>(quickrun)
"   if dein#tap('vim-quickrun')
"     let g:quickrun_config = {
"       \   '_': {
"       \     'outputter' : 'multi:buffer:quickfix',
"       \     'hook/close_quickfix/enable_success' : 1,
"       \     'hook/close_buffer/enable_failure' : 1,
"       \     'hook/neco/enable' : 1,
"       \     'hook/neco/wait' : 20,
"       \     'runner': 'vimproc',
"       \     'hook/time/enable' : 1
"       \   },
"       \   'tex':{
"       \     'command' : 'latexmk',
"       \     'outputter' : 'error',
"       \     'outputter/error/error' : 'quickfix',
"       \     'cmdopt': '-pv',
"       \     'exec': ['%c %o %s']
"       \   },
"       \ }
"   endif

  "" Git

  call dein#add('tpope/vim-fugitive')

  "" Editing support
  call dein#add('Shougo/deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})
  " for Nvim-R
"   if !exists('g:deoplete#omni_patterns')
"       let g:deoplete#omni_patterns = {}
"   endif
"   let g:deoplete#omni_patterns.r = '[[:alnum:].\\]\+'

  " Recognize charcode automatically
  call dein#add("banyan/recognize_charcode.vim")

  call dein#add('kana/vim-operator-user', {
    \ 'depends': ['vim-operator-replace', 'vim-operator-surround'],
    \ })
  call dein#add('kana/vim-operator-replace')
  if dein#tap('vim-operator-replace')
    nmap _ <Plug>(operator-replace)
  endif
  call dein#add('rhysd/vim-operator-surround')
  if dein#tap('vim-operator-surround')
    " 括弧を追加する
    map <silent> Sy <Plug>(operator-surround-append)
    " 括弧を削除する
    map <silent> Sd <Plug>(operator-surround-delete)
    " 括弧を入れ替える
    map <silent> Sc <Plug>(operator-surround-replace)
  endif

  "" Snippets
  call dein#add('Shougo/neosnippet', {
    \ 'on_map': ['<Plug>(neosnippet_expand_or_jump)',
    \            '<Plug>(neosnippet_expand_target)'],
    \ 'depends': ['neosnippet-snippets', 'vim-snippets'],
    \ 'lazy': 1})
  call dein#add('Shougo/neosnippet-snippets', {'lazy': 1})
  call dein#add('honza/vim-snippets', {'lazy': 1})

  " 対応する括弧等を入力する
  call dein#add('kana/vim-smartinput')

  " 素早くコメントアウトする
  call dein#add('tyru/caw.vim')
  " <Leader>c でカーソル行をコメントアウト
  " 再度 <Leader>c でコメントアウトを解除
  " 選択してから複数行の <Leader>c も可能
  nmap <Leader>c <Plug>(caw:zeropos:toggle)
  vmap <Leader>c <Plug>(caw:zeropos:toggle)
  " <Leader>C でコメントアウトの解除
  nmap <Leader>C <Plug>(caw:zeropos:uncomment)
  vmap <Leader>C <Plug>(caw:zeropos:uncomment)


  "" Language
  " Go
  call dein#add('fatih/vim-go', {'on_ft': 'go'})

  " R
  call dein#add('jalvesaq/Nvim-R')

  call dein#end()
endif

" Installation check.
if dein#check_install()
  call dein#install()
endif

colorscheme iceberg
filetype plugin indent on
syntax enable
