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
" キースワップ
"#######################
" map \ <leader>
let mapleader = ","
noremap \ ,

"" .vimrcの編集を簡単にする
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>

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

" 括弧を自動補完
" kana/vim-smartinput を入れたため、停止
" inoremap {{ {}<LEFT>
" inoremap [[ []<LEFT>
" inoremap (( ()<LEFT>
" inoremap "" ""<LEFT>
" inoremap '' ''<LEFT>
" inoremap $$ $$<LEFT>
" vnoremap { "zdi^V{<C-R>z}<ESC>
" vnoremap [ "zdi^V[<C-R>z]<ESC>
" vnoremap ( "zdi^V(<C-R>z)<ESC>
" vnoremap " "zdi^V"<C-R>z^V"<ESC>
" vnoremap ' "zdi'<C-R>z'<ESC>

" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする "
" inoremap <C-k>  <ESC>"*pa

"#######################
" 表示系
"#######################
" 文字コードの指定
" set enc=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,utf-8,euc-jp,cp932

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
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
"     let &t_SI = "\e]50;CursorShape=1\x7"
"     let &t_EI = "\e]50;CursorShape=0\x7"
  endif
endif

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
    autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
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
endif

"##################
" dein
"##################
let s:noplugin = 0
let s:dein_root = s:config_root . '/dein'
let s:deinvim_root = s:dein_root . '/repos/github.com/Shougo/dein.vim'
filetype off

if !isdirectory(s:deinvim_root) || v:version < 702
  let s:noplugin = 1
else
  if has('vim_starting')
    execute 'set runtimepath+=' . s:deinvim_root
  endif

  "call dein#add('Shougo/dein.vim')
  " Check cache
  if dein#load_state(expand('~/.cache/dein'))
    call dein#begin(expand('~/.cache/dein'))

    call dein#add('Shougo/dein.vim')

    " Enable async process via vimproc
    call dein#add('Shougo/vimproc', {
          \ 'build': {
          \     'windows': 'tools\\update-dll-mingw',
          \     'cygwin': 'make -f make_cygwin.mak',
          \     'mac': 'make -f make_mac.mak',
          \     'linux': 'make',
          \     'unix': 'gmake'}})

    " Recognize charcode automatically
    call dein#add("banyan/recognize_charcode.vim")

    " Style / Display {{{
    call dein#add('rainux/vim-desert-warm-256')
    call dein#add('nanotech/jellybeans.vim')
    call dein#add('cocopon/iceberg.vim')

    " ステータスラインをカスタマイズ
    call dein#add('itchyny/lightline.vim')
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
    " call dein#add('cohama/vim-hier')

    " インデントの可視化
    call dein#add('nathanaelkane/vim-indent-guides')
    if dein#tap('vim-indent-guides')
      let g:indent_guides_enable_on_vim_startup = 1
      let g:indent_guides_guide_size = 1
      let g:indent_guides_auto_colors = 0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
      let g:indent_guides_start_level= 2
    endif
"
    " File Management {{{

    call dein#add("Shougo/unite.vim", {
          \ "depends": ["neomru.vim"],
          \ 'on_cmd': ['Unite', 'UniteWithBufferDir'],
          \ 'lazy': 1})
    call dein#add('Shougo/neomru.vim', {
          \ 'lazy': 1,
          \ })
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
    if dein#tap("unite.vim")
      " start unite in insert mode
      let g:unite_enable_start_insert = 1
      function! s:unite_settings()
        " use vimfiler to open directory
        call unite#custom_default_action("source/bookmark/directory", "vimfiler")
        call unite#custom_default_action("directory", "vimfiler")
        call unite#custom_default_action("directory_mru", "vimfiler")
        imap <buffer> <Esc><Esc> <Plug>(unite_exit)
        nmap <buffer> <Esc> <Plug>(unite_exit)
        nmap <buffer> <C-n> <Plug>(unite_select_next_line)
        nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
      endfunction
      autocmd MyAutoCmd FileType unite call s:unite_settings()
    endif

    call dein#add('Shougo/vimfiler', {
          \ 'depends': ['unite.vim'],
          \ 'on_cmd': ['VimFilerTab', 'VimFiler', 'VimFilerExplorer'],
          \ 'on_map': ['<Plug>(vimfiler_switch)'],
          \ })
    nnoremap <Leader>e :VimFilerExplorer<CR>
    " close vimfiler automatically when there are only vimfiler open
    autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
    if dein#tap("vimfiler")
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
    endif

    " Vimからシェルを起動できる
    call dein#add('Shougo/vimshell.vim', {
          \ 'depends' : 'unite.vim',
          \ 'on_cmd' : [ 'VimShell',
          \              'VimShellExecute', 'VimShellInteractive',
          \              'VimShellTerminal', 'VimShellPop'],
          \ 'lazy' : 1,
          \ })
    nnoremap <silent> vs :VimShell<CR>
    nnoremap <silent> vsc :VimShellCreate<CR>
    nnoremap <silent> vp :VimShellPop<CR>

    " Editing support {{{
    call dein#add('kana/vim-operator-user')

    " 「S」で選択されたテキストを囲う
    call dein#add('rhysd/vim-operator-surround')
    map ys <Plug>(operator-surround-append)
    map ds <Plug>(operator-surround-delete)
    map cs <Plug>(operator-surround-replace)
    " call dein#add('tpope/vim-surround')

    " テキストオブジェクトで置換
    call dein#add('kana/vim-operator-replace.git')
    map R  <Plug>(operator-replace)

    " 対応する括弧等を入力する
    call dein#add('kana/vim-smartinput')

    " 置換する対象文字列をハイライトなど
    call dein#add('osyo-manga/vim-over')
    if dein#tap("vim-over")
      " over.vimの起動
      nnoremap <silent> <Leader>m :OverCommandLine<CR>
      " カーソル下の単語をハイライト付きで置換
      nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
      " コピーした文字列をハイライト付きで置換
      nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>
    endif

    " 素早くコメントアウトする
    call dein#add('tyru/caw.vim')
    " <Leader>c でカーソル行をコメントアウト
    " 再度 <Leader>c でコメントアウトを解除
    " 選択してから複数行の <Leader>c も可能
    nmap <Leader>c <Plug>(caw:I:toggle)
    vmap <Leader>c <Plug>(caw:I:toggle)
    " <Leader>C でコメントアウトの解除
    nmap <Leader>C <Plug>(caw:I:uncomment)
    vmap <Leader>C <Plug>(caw:I:uncomment)
    " 高性能なテキスト整形ツール
    " call dein#add('vim-scripts/Align')
    " ヤンクの履歴を管理し、順々に参照、出力
    call dein#add('vim-scripts/YankRing.vim')
    if dein#tap("YankRing.vim")
    let yankring_history_file = ".yankring_history"
    endif

    call dein#add('LeafCage/yankround.vim')
    if dein#tap("yankround.vim")
      nmap p <Plug>(yankround-p)
      xmap p <Plug>(yankround-p)
      nmap P <Plug>(yankround-P)
      nmap gp <Plug>(yankround-gp)
      xmap gp <Plug>(yankround-gp)
      nmap gP <Plug>(yankround-gP)
      nmap <C-p> <Plug>(yankround-prev)
      nmap <C-n> <Plug>(yankround-next)
      "let yankring_history_file = ".yankring_history"
    endif


    call dein#add('Shougo/deoplete.nvim')
    let g:deoplete#enable_at_startup = 1


    call dein#add('Shougo/neosnippet', {
             \ 'on_map': ['<Plug>(neosnippet_expand_or_jump)',
             \            '<Plug>(neosnippet_expand_target)'],
             \ 'depends': ['neosnippet-snippets', 'vim-snippets'],
             \ 'lazy': 1})
    call dein#add('Shougo/neosnippet-snippets', {'lazy': 1})
    call dein#add('honza/vim-snippets', {'lazy': 1})
    if dein#tap("neosnippet")
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
      let g:neosnippet#snippets_directory=s:dein_root . '/vim-snippets/snippets'
    endif

"           \ 'lazy': 1
    " Programming {{{
"     call dein#add('thinca/vim-quickrun')
    call dein#add('thinca/vim-quickrun', {
          \ 'depends' : 'shabadou.vim',
          \ 'on_map': [['nxo', '<Plug>(quickrun)']],
          \ 'lazy' : 1,
          \ })
"           \ 'depends': 'vim-quickrun',
"     call dein#add('osyo-manga/shabadou.vim')
    call dein#add('osyo-manga/shabadou.vim', {
          \ 'lazy' : 1,
          \ })
    nmap <Leader>r <Plug>(quickrun)
    if dein#tap('vim-quickrun')
      let g:quickrun_config = {
            \   '_': {
            \     'outputter' : 'multi:buffer:quickfix',
            \     'hook/close_quickfix/enable_success' : 1,
            \     'hook/close_buffer/enable_failure' : 1,
            \     'hook/neco/enable' : 1,
            \     'hook/neco/wait' : 20,
            \     'runner': 'vimproc',
            \     'hook/time/enable' : 1
            \   },
            \   'tex':{
            \     'command' : 'latexmk',
            \     'outputter' : 'error',
            \     'outputter/error/error' : 'quickfix',
            \     'cmdopt': '-pv',
            \     'exec': ['%c %o %s']
            \   },
            \ }
    endif

    call dein#add('ujihisa/repl.vim')

    " シンタックスチェックプラグイン
  "   call dein#add('scrooloose/syntastic', {
  "         \ 'build': {
  "         \   'mac': ['pip install pyflake', 'npm -g install coffeelint'],
  "         \   'unix': ['pip install pyflake', 'npm -g install coffeelint'],
  "         \ }})
  "   ' let g:syntastic_python_checkers = ['pyflakes', 'pep8']
  "   let g:syntastic_disabled_filetypes = ['html', 'tex']

    call dein#add('mattn/emmet-vim', {'autoload': {
          \ 'filetypes': ['html', 'css', 'scss', 'sass', 'jinja2'] },
          \ 'lazy': 1})

    " Vimで正しくvirtualenvを処理できるようにする
    call dein#add('jmcantrell/vim-virtualenv', {
          \ 'autoload': {
          \   'filetypes': ['python', 'python3', 'jinja2']
          \ },
          \ 'lazy': 1})
    call dein#add('vim-scripts/python_match.vim', {
          \ 'autoload': {
          \   'filetypes': ['python', 'python3', 'jinja2']
          \ },
          \ 'lazy': 1})
    call dein#add('mjbrownie/django-template-textobjects', {
          \ 'depends': ['vim-textobj-user'],
          \ 'autoload': {
          \   'filetypes': ['python', 'python3', 'jinja2']
          \ },
          \ 'lazy': 1})
    call dein#add('davidhalter/jedi-vim', {
        \ 'autoload': {
        \   'filetypes': ['python', 'python3', 'jinja2'],
        \ },
        \ 'build': {
        \   'mac': 'pip install jedi',
        \   'unix': 'pip install jedi',
        \ },
        \ 'lazy': 1})
    if dein#tap("jedi-vim")
      let g:jedi#auto_vim_configuration = 0
      let g:jedi#popup_select_first = 0
      " jedi#show_function_definitionは非推奨
      "let g:jedi#show_function_definition = 1
      let g:jedi#show_call_signatures = 1
      let g:jedi#rename_command = '<Leader>R'
      " jedi#goto_commandは非推奨
      " let g:jedi#goto_command = '<Leader>G'
      let g:jedi#goto_assignments_command = '<Leader>G'
    endif

    call dein#end()

    call dein#save_state()
  endif

  " Installation check.
  if dein#check_install()
    call dein#install()
  endif
endif
"colorscheme jellybeans
colorscheme iceberg
filetype plugin indent on
