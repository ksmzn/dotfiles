" vim: foldlevel=0 sts=2 sw=2 smarttab et ai textwidth=0
if !&compatible
  " disable vi compatible features
  set nocompatible
endif

" Skip initialization for vim-tiny or vim-small
if !1 | finish | endif

"#######################
" Variables
"#######################
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand("~/.gvimrc")
endif

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_darwin = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux = !s:is_windows && !s:is_cygwin && !s:is_darwin

let s:config_root = expand('~/.vim')
let s:bundle_root = s:config_root . '/bundle'

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

" reset runtimepath
if has('vim_starting')
  if s:is_windows
    " set runtimepath
    let &runtimepath = join([
          \ s:config_root,
          \ expand('$VIM/runtime'),
          \ s:config_root . '/after'], ',')
  else
    " reset runtimepath to default
    set runtimepath&
  endif

endif

"#######################
" キースワップ
"#######################
map ¥ <leader>

"" .vimrcの編集を簡単にする
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>
" .vimrcや.gvimrcを変更すると、自動的に変更が反映されるようにする
augroup MyAutoCmd
  autocmd!
augroup END

if !has('gui_running') && !(has('win32') || has('win64'))
  " .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
  " .vimrcの再読込時にも色が変化するようにする
  autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
        \if has('gui_running') | source $MYGVIMRC
  autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif
""}}}

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
"#######################
" 表示系
"#######################
" 文字コードの指定
set enc=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,utf-8,euc-jp,cp932

set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
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
highlight CursorLine ctermbg=black guibg=black

" iTerm2で、カーソルの形状を変更
let &t_SI = "\e]50;CursorShape=1\x7"
let &t_EI = "\e]50;CursorShape=0\x7"

"全角スペース
highlight JpSpace cterm=underline ctermfg=Blue guifg=Blue
au BufRead,BufNew * match JpSpace /　/

" texのconcealを無効化（#^ω^）
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

set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=4 sts=4 ts=8 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=8 et
  autocmd FileType kivy     setlocal sw=4 sts=4 ts=8 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
endif

augroup FileTypeDetect
  autocmd!
  autocmd BufNewFile,BufRead *.tex,*.latex,*.sty,*.dtx,*.ltx,*.bbl setf tex
  autocmd BufNewFile,BufRead *.md  setf markdown
  autocmd BufNewFile,BufRead *.less setf less
  autocmd BufNewFile,BufRead *.coffee setf coffee
  autocmd BufNewFile,BufRead *.erb setf html
  autocmd BufNewFile,BufRead *.kv setf kivy
augroup END

" 特定のファイルの時に雛形を表示
autocmd BufNewFile *.py 0r $HOME/.vim/template/python.py
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
set nocompatible "vi非互換モード
"set nowritebackup
"" set nobackup
"set backup
"" set noswapfile " No Swap
"set swapfile
"set noundofile " .un~ファイルを作らない

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
endif

" 括弧を自動補完
inoremap {{ {}<LEFT>
inoremap [[ []<LEFT>
inoremap (( ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする "
" inoremap <C-k>  <ESC>"*pa

"##################
" NeoBundle
"##################
let s:noplugin = 0
let s:neobundle_root = s:bundle_root . "/neobundle.vim"
filetype off

if !isdirectory(s:neobundle_root) || v:version < 702
  let s:noplugin = 1
else
  if has('vim_starting')
    execute "set runtimepath+=" . s:neobundle_root
  endif
  call neobundle#rc(s:bundle_root)

  " Let NeoBundle manage NeoBundle
  NeoBundleFetch 'Shougo/neobundle.vim'

  " Enable async process via vimproc
  NeoBundle "Shougo/vimproc", {
        \ "build": {
        \   "windows"   : "make -f make_mingw32.mak",
        \   "cygwin"    : "make -f make_cygwin.mak",
        \   "mac"       : "make -f make_mac.mak",
        \   "unix"      : "make -f make_unix.mak",
        \ }}

  " Recognize charcode automatically
  NeoBundle "banyan/recognize_charcode.vim"

  " Style / Display {{{
  NeoBundle 'rainux/vim-desert-warm-256'
  NeoBundle 'nanotech/jellybeans.vim'
  colorscheme jellybeans
  NeoBundle 'itchyny/landscape.vim'
  NeoBundle 'w0ng/vim-hybrid'
  " colorscheme hybrid
  NeoBundle 'vim-scripts/twilight'
  NeoBundle 'jonathanfilip/vim-lucius'
  NeoBundle 'jpo/vim-railscasts-theme'
  NeoBundle 'altercation/vim-colors-solarized'
  NeoBundle 'vim-scripts/Wombat'
  NeoBundle 'tomasr/molokai'
  NeoBundle 'vim-scripts/rdark'

  " ステータスラインをカスタマイズ
  NeoBundle 'itchyny/lightline.vim'
  let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'component': {
        \   'readonly': '%{&readonly?"⭤":""}',
        \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
        \ },
        \ 'component_visible_condition': {
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
        \ },
        \ 'separator': { 'left': '⮀', 'right': '⮂' },
        \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
        \ }

  " QuickFix の該当箇所をハイライト
  " NeoBundle 'cohama/vim-hier'

  " インデントの可視化
  NeoBundle "nathanaelkane/vim-indent-guides"
  let s:hooks = neobundle#get_hooks("vim-indent-guides")
  function! s:hooks.on_source(bundle)
    let g:indent_guides_guide_size = 1
    nnoremap <silent> [toggle]i  :IndentGuidesToggle<CR>
    IndentGuidesEnable
  endfunction

  " マークの表示
  " NeoBundleLazy 'vim-scripts/ShowMarks', {
  "       \ 'autoload': {
  "       \   'commands': ['ShowMarksPlaceMark', 'ShowMarksToggle'],
  "       \ }}
  " nnoremap [showmarks] <Nop>
  " nmap M [showmarks]
  " nnoremap [showmarks]m :ShowMarksPlaceMark<CR>
  " nnoremap [showmarks]t :ShowMarksToggle<CR>
  " let s:hooks = neobundle#get_hooks("ShowMarks")
  " function! s:hooks.on_source(bundle)
  "   let showmarks_text = '»'
  "   let showmarks_textupper = '»'
  "   let showmarks_textother = '»'
  "   let showmarks_hlline_lower = 0
  "   let showmarks_hlline_upper = 1
  "   let showmarks_hlline_other = 0
  "   " ignore ShowMarks on buffer type of
  "   " Help, Non-modifiable, Preview Quickfix
  "   let showmarks_ignore_type = 'hmpq'
  " endfunction

  NeoBundleLazy "skammer/vim-css-color", {
        \ "autoload": {
        \   "filetypes": ["html", "css", "less", "sass", "javascript", "coffee", "coffeescript", "djantohtml"],
        \ }}
  " }}}

  " Syntax / Indent / Omni {{{
  " syntax /indent /filetypes for git
  NeoBundleLazy 'tpope/vim-git', {'autoload': {
        \ 'filetypes': 'git' }}
  " syntax for CSS3
  NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload': {
        \ 'filetypes': 'css' }}
  " syntax for HTML5
  NeoBundleLazy 'othree/html5.vim', {'autoload': {
        \ 'filetypes': ['html', 'djangohtml'] }}
  " syntax /indent /omnicomplete for LESS
  NeoBundleLazy 'groenewege/vim-less.git', {'autoload': {
        \ 'filetypes': 'less' }}
  " syntax for SASS
  NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload': {
        \ 'filetypes': 'sass' }}
  " QML
  NeoBundleLazy "peterhoeg/vim-qml", {'autoload': {
        \ 'filetypes': ['qml', 'qml/qmlscene'] }}
  " }}}

  " File Management {{{

  NeoBundle "thinca/vim-template"
  autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
  function! s:template_keywords()
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! %s/<+FILENAME+>/\=expand('%:r')/g
  endfunction
  autocmd MyAutoCmd User plugin-template-loaded
        \   if search('<+CURSOR+>')
        \ |   silent! execute 'normal! "_da>'
        \ | endif

  "NeoBundle "Shougo/unite.vim"
  NeoBundleLazy "Shougo/unite.vim", {
        \ "depends": ["Shougo/neomru.vim"],
        \ "autoload": {
        \   "commands": ["Unite", "UniteWithBufferDir"]
        \ }}
  "NeoBundle 'Shougo/neomru.vim'
  "NeoBundleLazy 'Shougo/neomru.vim', {
  "      \ "depends": ["Shougo/unite.vim"]
  "      \ }
  " カラースキーム一覧表示に Unite.vim を使う
  NeoBundleLazy 'ujihisa/unite-colorscheme'
  " アウトライナー
  NeoBundleLazy 'h1mesuke/unite-outline', {
        \ "autoload": {
        \   "unite_sources": ["outline"],
        \ }}
  nnoremap [unite] <Nop>
  nmap U [unite]
  nnoremap <silent> [unite]d :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  nnoremap <silent> [unite]f :<C-u>Unite file<CR>
  nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
  nnoremap <silent> [unite]r :<C-u>Unite register<CR>
  nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
  nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
  nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
  nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
  nnoremap <silent> [unite]w :<C-u>Unite window<CR>
  let s:hooks = neobundle#get_hooks("unite.vim")
  function! s:hooks.on_source(bundle)
    " start unite in insert mode
    let g:unite_enable_start_insert = 1
    " use vimfiler to open directory
    call unite#custom_default_action("source/bookmark/directory", "vimfiler")
    call unite#custom_default_action("directory", "vimfiler")
    call unite#custom_default_action("directory_mru", "vimfiler")
    autocmd MyAutoCmd FileType unite call s:unite_settings()
    function! s:unite_settings()
      imap <buffer> <Esc><Esc> <Plug>(unite_exit)
      nmap <buffer> <Esc> <Plug>(unite_exit)
      nmap <buffer> <C-n> <Plug>(unite_select_next_line)
      nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
    endfunction
  endfunction

  NeoBundleLazy "Shougo/vimfiler", {
        \ "depends": ["Shougo/unite.vim"],
        \ "autoload": {
        \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
        \   "mappings": ['<Plug>(vimfiler_switch)'],
        \   "explorer": 1,
        \ }}
  nnoremap <Leader>e :VimFilerExplorer<CR>
  " close vimfiler automatically when there are only vimfiler open
  autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
  let s:hooks = neobundle#get_hooks("vimfiler")
  function! s:hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_enable_auto_cd = 1

    " ignore swap, backup, temporary files
    let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"

    " vimfiler specific key mappings
    autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
    function! s:vimfiler_settings()
      " ^^ to go up
      nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
      " use R to refresh
      nmap <buffer> R <Plug>(vimfiler_redraw_screen)
      " overwrite C-l ignore <Plug>(vimfiler_redraw_screen)
      nmap <buffer> <C-l> <C-w>l
      " overwrite C-j ignore <Plug>(vimfiler_switch_to_history_directory)
      nmap <buffer> <C-j> <C-w>j
    endfunction
  endfunction

  " Vimからシェルを起動できる
  NeoBundleLazy 'Shougo/vimshell.vim', {
        \ 'depends' : [ 'Shougo/vimproc.vim' ],
        \ 'autoload' : {
        \ 'commands' : [{ 'name' : 'VimShell',
        \                 'complete' : 'customlist,vimshell#complete'},
        \                 'VimShellExecute', 'VimShellInteractive',
        \                 'VimShellTerminal', 'VimShellPop'],
        \ }}
  nnoremap <silent> vs :VimShell<CR>
  nnoremap <silent> vsc :VimShellCreate<CR>
  nnoremap <silent> vp :VimShellPop<CR>
  " NeoBundle 'Shougo/vimshell.vim'
  " let s:hooks = neobundle#get_hooks("vimshell")
  " function! s:hooks.on_source(bundle)
  "   " ,is: シェルを起動
  "   nnoremap <silent> ,is :VimShell<CR>
  "   " ,ipy: pythonを非同期で起動
  "   nnoremap <silent> ,ipy :VimShellInteractive python<CR>
  "   " ,irb: irbを非同期で起動
  "   nnoremap <silent> ,irb :VimShellInteractive irb<CR>
  "   " ,ss: 非同期で開いたインタプリタに現在の行を評価させる
  "   vmap <silent> ,ss :VimShellSendString<CR>
  "   " 選択中に,ss: 非同期で開いたインタプリタに選択行を評価させる
  "   nnoremap <silent> ,ss <S-v>:VimShellSendString<CR>
  " endfunction

  " gistクライアント
  NeoBundleLazy "mattn/gist-vim", {
        \ "depends": ["mattn/webapi-vim"],
        \ "autoload": {
        \   "commands": ["Gist"],
        \ }}

  " gitラッパープラグイン
  " vim-fugitive use `autocmd` a lost so cannot be loaded with Lazy
  NeoBundle "tpope/vim-fugitive"
  "NeoBundleLazy "tpope/vim-fugitive", {
  "      \ "autoload": {
  "      \   "commands": [
  "      \     "Gstatus", "Gwrite", "Gread", "Gmove",
  "      \     "Gremove", "Gcommit", "Gblame", "Gdiff",
  "      \     "Gbrowse",
  "      \ ]}}
  " Git の GUI ツールと同等のこと行えるプラグイン
  NeoBundleLazy "gregsexton/gitv", {
        \ "depends": ["tpope/vim-fugitive"],
        \ "autoload": {
        \   "commands": ["Gitv"],
        \ }}
  "}}}

  " Editing support {{{
  " 置換する対象文字列をハイライトなど
  NeoBundle 'osyo-manga/vim-over'
  let s:hooks = neobundle#get_hooks("vim-over")
  function! s:hooks.on_source(bundle)
    " over.vimの起動
    nnoremap <silent> <Leader>m :OverCommandLine<CR>
    " カーソル下の単語をハイライト付きで置換
    nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
    " コピーした文字列をハイライト付きで置換
    nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>
  endfunction

  " 素早くコメントアウトする
  NeoBundle "tyru/caw.vim"
  " \c でカーソル行をコメントアウト
  " 再度 \c でコメントアウトを解除
  " 選択してから複数行の \c も可能
  nmap \c <Plug>(caw:I:toggle)
  vmap \c <Plug>(caw:I:toggle)
  " \C でコメントアウトの解除
  nmap \C <Plug>(caw:I:uncomment)
  vmap \C <Plug>(caw:I:uncomment)

  " 「S」で選択されたテキストを囲う
  NeoBundle 'tpope/vim-surround'
  " 高性能なテキスト整形ツール
  " NeoBundle 'vim-scripts/Align'
  " ヤンクの履歴を管理し、順々に参照、出力
  "NeoBundle 'vim-scripts/YankRing.vim'
  "let s:hooks = neobundle#get_hooks("YankRing.vim")
  "function! s:hooks.on_source(bundle)
  "  let yankring_history_file = ".yankring_history"
  "endfunction

  NeoBundle 'LeafCage/yankround.vim'
  let s:hooks = neobundle#get_hooks("yankround.vim")
  function! s:hooks.on_source(bundle)
    nmap p <Plug>(yankround-p)
    xmap p <Plug>(yankround-p)
    nmap P <Plug>(yankround-P)
    nmap gp <Plug>(yankround-gp)
    xmap gp <Plug>(yankround-gp)
    nmap gP <Plug>(yankround-gP)
    nmap <C-p> <Plug>(yankround-prev)
    nmap <C-n> <Plug>(yankround-next)
    "let yankring_history_file = ".yankring_history"
  endfunction


  " もしneocompleteが使えない場合, neocomplcacheを使用する
  " if has('lua') && v:version >= 703 && has('patch885')
  " if has('lua') && (v:version >= 703 || has('patch885'))
  if has('lua') && v:version >= 703
    NeoBundleLazy 'Shougo/neocomplete.vim', {
          \ 'autoload': {
          \   'insert': 1,
          \ }}
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
      " Disable AutoComplPop.
      let g:acp_enableAtStartup = 0
      " Use neocomplete.
      " let g:neocomplete#enable_at_startup = 1
      " Use smartcase.
      let g:neocomplete#enable_smart_case = 1
      " Set minimum syntax keyword length.
      let g:neocomplete#sources#syntax#min_keyword_length = 3
      " <TAB>: completion.
      inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
      inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
      " Close popup by <Space>.
      " inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
      " Enable omni completion.
      autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
      autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
      autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
      autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
      " Enable heavy omni completion.
      if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
      endif
    endfunction
    function! s:hooks.on_post_source(bundle)
      NeoCompleteEnable
    endfunction
  else
    NeoBundleLazy 'Shougo/neocomplcache.vim', {
          \ 'autoload': {
          \   'insert': 1,
          \ }}
    " NeoComplCache を有効化
    let g:neocomplcache_enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplcache.vim")
    function! s:hooks.on_source(bundle)
      let g:acp_enableAtStartup = 0
      let g:neocomplcache_enable_smart_case = 1
      let g:neocomplcache_min_syntax_length = 3
      " <TAB> で補完候補の選択
      inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    endfunction
  endif

  NeoBundleLazy 'Shougo/neosnippet', {
        \ "depends": ["honza/vim-snippets", "Shougo/neosnippet-snippets"],
        \ "autoload": {
        \   "insert": 1,
        \ }}
  let s:hooks = neobundle#get_hooks("neosnippet")
  function! s:hooks.on_source(bundle)
    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    " imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    "       \ "\<Plug>(neosnippet_expand_or_jump)"
    "       \: pumvisible() ? "\<C-n>" : "\<TAB>"
    " smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    "       \ "\<Plug>(neosnippet_expand_or_jump)"
    "       \: "\<TAB>"
    " <Tab>で候補移動, <Enter>で展開
    imap <expr><CR> neosnippet#expandable() <bar><bar>
            \ neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \ : "\<CR>"
    imap <expr><TAB> pumvisible() ? "\<C-n>" 
            \ : neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \ : "\<TAB>"
    smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
    " Enable snipMate compatibility feature.
    let g:neosnippet#enable_snipmate_compatibility = 1
    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory=s:bundle_root . '/vim-snippets/snippets'
  endfunction

  " Vim のアンドゥツリー可視化
  NeoBundleLazy "sjl/gundo.vim", {
        \ "autoload": {
        \   "commands": ['GundoToggle'],
        \}}
  nnoremap <Leader>g :GundoToggle<CR>

  " ToDo管理
  NeoBundleLazy "vim-scripts/TaskList.vim", {
        \ "autoload": {
        \   "mappings": ['<Plug>TaskList'],
        \}}
  nmap <Leader>T <plug>TaskList

  " ブラウジング
  NeoBundle 'yuratomo/w3m.vim'
  "}}}

  " Programming {{{
  NeoBundleLazy "thinca/vim-quickrun", {
        \ 'autoload': {
        \   'mappings': [['nxo', '<Plug>(quickrun)']]
        \ }}
  " NeoBundle 'thinca/vim-quickrun'
  nmap <Leader>r <Plug>(quickrun)
  let s:hooks = neobundle#get_hooks("vim-quickrun")
  function! s:hooks.on_source(bundle)
    let g:quickrun_config = {
          \   "_": {
          \     "runner": "vimproc",
          \     'hook/time/enable' : 1
          \   },
          \   'tex':{
          \     'command' : 'latexmk',
          \     'cmdopt': '-pdfdvi',
          \     'exec': ['%c %o %s', 'open %s:r.pdf']
          \   },
          \ }
    "\ 'hook/time/enable' : 1,
"           \   'outputter/error/error' : 'buffer',
"     let g:quickrun_config['tex'] = {
"           \   'command' : 'latexmk',
"           \   'outputter' : 'error',
"           \   'outputter/error/error' : 'quickfix',
"           \   'cmdopt': '-pdfdvi',
"           \   'exec': ['%c %o %s']
"           \ }
"           \     'exec': ['%c %o %s', 'open %s:r.pdf']
"           \     'outputter/error/success' : 'buffer',
"           \     'outputter/error/error' : 'quickfix',
"           \     'outputter' : 'error',
"           \     'outputter' : 'quickfix',
  endfunction

  " タグジャンプ
  NeoBundle 'majutsushi/tagbar'
  "NeoBundleLazy 'majutsushi/tagbar', {
  "      \ "verbose" : 1,
  "      \ "autload": {
  "      \   "commands": ["TagbarToggle"],
  "      \ },
  "      \ "build": {
  "      \   "mac": "brew install ctags",
  "      \ }}
  nmap <Leader>t :TagbarToggle<CR>

  " シンタックスチェックプラグイン
  NeoBundle "scrooloose/syntastic", {
        \ "build": {
        \   "mac": ["pip install pyflake", "npm -g install coffeelint"],
        \   "unix": ["pip install pyflake", "npm -g install coffeelint"],
        \ }}
  " let g:syntastic_python_checkers = ['pyflakes', 'pep8']

  " PythonコードがPEP8に従うように自動修正
  NeoBundleLazy 'tell-k/vim-autopep8', {'autoload': {
        \ 'filetypes': ['python', 'python3'] }}
  let s:hooks = neobundle#get_hooks("vim-autopep8")
  function! s:hooks.on_source(bundle)
    " Shift + F で自動修正
    autocmd FileType python map <buffer> <S-f> :call Autopep8()<CR>
  endfunction

  " PHPコードがPSR-2に従うように自動修正
  NeoBundleLazy 'stephpy/vim-php-cs-fixer', {
        \ 'autoload': {'filetypes': ['php'] }
        \ }
  "NeoBundle 'fabpot/PHP-CS-Fixer'
  let s:hooks = neobundle#get_hooks("vim-php-cs-fixer")
  function! s:hooks.on_source(bundle)
    " If php-cs-fixer is in $PATH, you don't need to define line below
    " let g:php_cs_fixer_path = "~/php-cs-fixer.phar" " define the path to the php-cs-fixer.phar
    let g:php_cs_fixer_level = "all"                  " which level ?
    let g:php_cs_fixer_config = "default"             " configuration
    let g:php_cs_fixer_php_path = "php"               " Path to PHP
    " If you want to define specific fixers:
    "let g:php_cs_fixer_fixers_list = "linefeed,short_tag,indentation"
    let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
    let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
    let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
    nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
    nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
  endfunction

  " デバッガ
  NeoBundleLazy 'joonty/vdebug', {'autoload': {
        \ 'filetypes': ['php'] }}

  " C++
  NeoBundleLazy 'vim-jp/cpp-vim', {
              \ 'autoload' : {'filetypes' : 'cpp'}
              \ }
  " jQuery
  NeoBundleLazy "jQuery", {'autoload': {
        \ 'filetypes': ['coffee', 'coffeescript', 'javascript', 'html', 'djangohtml'] }}
  " CoffeeScript
  NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload': {
        \ 'filetypes': ['coffee', 'coffeescript'] }}

  " NeoBundleLazy 'mattn/zencoding-vim', {'autoload': {
  NeoBundleLazy 'mattn/emmet-vim', {'autoload': {
        \ 'filetypes': ['html', 'css', 'scss', 'sass', 'djangohtml'] }}

  " Julia
  "NeoBundle 'JuliaLang/julia-vim'
  "NeoBundleLazy 'JuliaLang/julia-vim', {
  "      \ 'verbose' : 1,
  "      \ 'autoload': {'filetypes': ['julia']}
  "      \ }
  NeoBundleLazy "JuliaLang/julia-vim", {
        \ "autoload": {
        \   "filetypes": ["julia"]
        \ }}

  " Python {{{
   NeoBundleLazy "lambdalisue/vim-django-support", {
         \ "autoload": {
         \   "filetypes": ["python", "python3", "djangohtml"]
         \ }}
  " Vimで正しくvirtualenvを処理できるようにする
  " NeoBundleLazy "jmcantrell/vim-virtualenv", {
  "       \ "autoload": {
  "       \   "filetypes": ["python", "python3", "djangohtml"]
  "       \ }}
   NeoBundleLazy "vim-scripts/python_match.vim", {
         \ "autoload": {
         \   "filetypes": ["python", "python3", "djangohtml"]
         \ }}
   NeoBundleLazy "mjbrownie/django-template-textobjects", {
         \ "depends": ["kana/vim-textobj-user"],
         \ "autoload": {
         \   "filetypes": ["python", "python3", "djangohtml"]
         \ }}
  NeoBundleLazy "davidhalter/jedi-vim", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"],
      \ },
      \ "build": {
      \   "mac": "pip install jedi",
      \   "unix": "pip install jedi",
      \ }}
  let s:hooks = neobundle#get_hooks("jedi-vim")
  function! s:hooks.on_source(bundle)
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_select_first = 0
    " jedi#show_function_definitionは非推奨
    "let g:jedi#show_function_definition = 1
    let g:jedi#show_call_signatures = 1
    let g:jedi#rename_command = '<Leader>R'
    " jedi#goto_commandは非推奨
    " let g:jedi#goto_command = '<Leader>G'
    let g:jedi#goto_assignments_command = '<Leader>G'
  endfunction

  "let s:hooks = neobundle#get_hooks("jedi-vim")
  "function! s:hooks.on_source(bundle)
  "  " jediにvimの設定を任せると'completeopt+=preview'するので
  "  " 自動設定機能をOFFにし手動で設定を行う
  "  let g:jedi#auto_vim_configuration = 0
  "  " 補完の最初の項目が選択された状態だと使いにくいためオフにする
  "  let g:jedi#popup_select_first = 0
  "  let g:jedi#show_function_definition = 1
  "  " quickrunと被るため大文字に変更
  "  " let g:jedi#rename_command = '<Leader>R'
  "  " ↑が効かなかったので、下のように設定
  "  " rename用のマッピングを無効にしたため、代わりにコマンドを定義
  "  command! -nargs=0 JediRename :call jedi#rename()
  "  " pythonのrename用のマッピングがquickrunとかぶるため回避させる
  "  let g:jedi#rename_command = ''
  "  " gundoと被るため大文字に変更
  "  let g:jedi#goto_command = '<Leader>G'
  "  " docstringは表示しない
  "  " autocmd FileType python setlocal completeopt-=preview
  "  " edi-vimとneocompleteの連携
  "  autocmd FileType python setlocal omnifunc=jedi#completions
  "  let g:jedi#completions_enabled = 0
  "  if !exists('g:neocomplete#force_omni_input_patterns')
  "          let g:neocomplete#force_omni_input_patterns = {}
  "  endif
  "  let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
  "endfunction
  " }}}
  "
  " Lisp, Scheme
  "NeoBundle 'amdt/vim-niji'
  "NeoBundleLazy 'aharisu/vim_goshrepl', {
  "      \ 'autoload': {
  "      \   'filetypes': ['lisp', 'scheme']
  "      \ }}
  "let s:bundle = neobundle#get_hooks("vim_goshrepl")
  "function! s:hooks.on_source(bundle)
  "  let g:neocomplete#keyword_patterns = {}
  "  let g:neocomplete#keyword_patterns['gosh-repl'] = \
  "  '[[:alpha:]+*/@$_=.!?-][[:alnum:]+*/@$_:=.!?-]*'
  "endfunction
  "NeoBundleLazy 'aharisu/vim-gdev', {
  "      \ 'autoload': {
  "      \   'filetypes': ['lisp', 'scheme']
  "      \ }}
  "let s:bundle = neobundle#get_hooks("vim-gdev")
  "function! s:hooks.on_source(bundle)
  "  ":Unite gosh_infoを実行します
  "  nmap gi <Plug>(gosh_info_start_search)
  "  ":Unite カーソル位置のシンボルを初期値に:Unite gosh_infoを実行します
  "  nmap gk <Plug>(gosh_info_start_search_with_cur_keyword)
  "  imap <C-A> <Plug>(gosh_info_start_search_with_cur_keyword)

  "  "ginfoウィンドウのスクロールアップ・ダウン
  "  nmap <C-K> <Plug>(gosh_info_row_up)
  "  nmap <C-J> <Plug>(gosh_info_row_down)
  "  imap <C-K> <Plug>(gosh_info_row_up)
  "  imap <C-J> <Plug>(gosh_info_row_down)
  "  "ginfoウィンドウを閉じます
  "  nmap <C-C> <Plug>(gosh_info_close)
  "  imap <C-C> <Plug>(gosh_info_close)

  "  "カーソル位置のシンボルが定義されている場所にジャンプ
  "  nmap <F12> <Plug>(gosh_goto_define)
  "  nmap <F11> <Plug>(gosh_goto_define_split)
  "endfunction


  " LaTeX
  "NeoBundle 'jcf/vim-latex'
  "NeoBundleLazy 'jcf/vim-latex', {
  "      \ 'autoload': {
  "      \   'filetypes': ['tex']
  "      \ }}
  "let s:bundle = neobundle#get_hooks("vim-latex")
  "function! s:hooks.on_source(bundle)
  "  let OSTYPE = system('uname')
  "  if OSTYPE == "Darwin\n"
  "    set shellslash
  "    set grepprg=grep\ -nH\ $*
  "    let tex_flavor = 'latex'
  "    let g:Tex_DefaultTargetFormat = 'pdf'
  "    let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
  "    let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
  "    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
  "    let g:Tex_ViewRule_pdf = 'open -a Preview.app'
  "  elseif OSTYPE == "Linux\n"
  "    set shellslash
  "    set grepprg=grep\ -nH\ $*
  "    let g:tex_flavor='latex'
  "    let g:Imap_UsePlaceHolders = 1
  "    let g:Imap_DeleteEmptyPlaceHolders = 1
  "    let g:Imap_StickyPlaceHolders = 0
  "    let g:Tex_DefaultTargetFormat = 'pdf'
  "    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
  "    let g:Tex_FormatDependency_ps = 'dvi,ps'
  "    let g:Tex_CompileRule_dvi = '/usr/bin/platex -shell-escape -interaction=nonstopmode $*'
  "    let g:Tex_CompileRule_pdf = '/usr/bin/dvipdfmx $*.dvi'
  "    let g:Tex_BibtexFlavor = '/usr/bin/pbibtex'
  "    let g:Tex_ViewRule_dvi = '/usr/bin/gnome-open'
  "    let g:Tex_ViewRule_pdf = '/usr/bin/gnome-open'
  "  endif
  "endfunction
  "unlet s:bundle  "}}}

  " install missing plugins
  NeoBundleCheck

  unlet s:hooks
endif
filetype plugin indent on

