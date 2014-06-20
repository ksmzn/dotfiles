filetype off
"#######################
" キースワップ
"#######################
map ¥ <leader>

"" .vimrcの編集を簡単にする
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>
" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> <Space>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> <Space>rg :<C-u>source $MYGVIMRC<CR>
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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

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
set nowritebackup
set nobackup
set noswapfile " No Swap
set noundofile " .un~ファイルを作らない

let g:VimShell_EnableInteractive = 1 "vimshell
" カーソルを自動的に()の中へ
"imap {} {}<Left>
"imap [] []<Left>
"imap () ()<Left>
"imap "" ""<Left>
"imap '' ''<Left>
"imap <> <><Left>
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
inoremap <C-k>  <ESC>"*pa


"###################################################################################################################
" NeoBundle
"###################################################################################################################
" NeoBundle がインストールされていない時、
" もしくは、プラグインの初期化に失敗した時の処理
"function! s:WithoutBundles()
"  "colorscheme desert
"  " その他の処理
"endfunction
if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" NeoBundle よるプラグインのロードと各プラグインの初期化
"function! s:LoadBundles()
  " 読み込むプラグインの指定
call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

" もしneocompleteが使えない場合, neocomplcacheを使用する
if has('lua') && v:version >= 703 && has('patch885')
    NeoBundleLazy "Shougo/neocomplete.vim", {
        \ "autoload": {
        \   "insert": 1,
        \ }}
    " 2013-07-03 14:30 NeoComplCacheに合わせた
    let g:neocomplete#enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplet#enable_smart_case = 1
        " NeoCompleteを有効化
        " NeoCompleteEnable
    endfunction
else
    NeoBundleLazy "Shougo/neocomplcache.vim", {
        \ "autoload": {
        \   "insert": 1,
        \ }}
    " 2013-07-03 14:30 原因不明だがNeoComplCacheEnableコマンドが見つからないので変更
    let g:neocomplcache_enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplcache.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplcache_enable_smart_case = 1
        " NeoComplCacheを有効化
        " NeoComplCacheEnable 
    endfunction
endif


  " カラースキーマ
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

  " カラースキーム一覧表示に Unite.vim を使う
  NeoBundleLazy "Shougo/unite.vim", {
      \ "autoload": {
      \   "commands": ["Unite", "UniteWithBufferDir"]
      \ }}
  NeoBundle 'ujihisa/unite-colorscheme'
  "NeoBundle 'git://github.com/mattn/zencoding-vim.git'
  " NeoBundleLazy 'mattn/zencoding-vim', {
  "     \ 'autoload': {'filetypes': ['html']}}

  " Web系
  " NeoBundle 'mattn/emmet-vim'
  NeoBundleLazy 'mattn/emmet-vim', {
      \ 'autoload': {'filetypes': ['html', 'eruby']}}

  NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {
      \ 'autoload': {'filetypes': ['html', 'javascript']}}
  let g:used_javascript_libs = 'angularjs'

  "NeoBundle 'scrooloose/nerdtree.git'
  NeoBundle 'thinca/vim-quickrun.git'
  NeoBundle 'kien/ctrlp.vim'
  NeoBundle 'tpope/vim-surround'
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
  NeoBundle "nathanaelkane/vim-indent-guides"
    let s:hooks = neobundle#get_hooks("vim-indent-guides")
    function! s:hooks.on_source(bundle)
      let g:indent_guides_guide_size = 1
      IndentGuidesEnable
    endfunction

  " Vimで正しくvirtualenvを処理できるようにする
  NeoBundleLazy "jmcantrell/vim-virtualenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}

   NeoBundleLazy "davidhalter/jedi-vim", {
       \ "autoload": {
       \   "filetypes": ["python", "python3", "djangohtml"],
       \   "build": {
       \     "mac": "pip install jedi",
       \     "unix": "pip install jedi",
       \   }
       \ }}
   let s:hooks = neobundle#get_hooks("jedi-vim")
   function! s:hooks.on_source(bundle)
     " jediにvimの設定を任せると'completeopt+=preview'するので
     " 自動設定機能をOFFにし手動で設定を行う
     let g:jedi#auto_vim_configuration = 0
     " 補完の最初の項目が選択された状態だと使いにくいためオフにする
     let g:jedi#popup_select_first = 0
     " quickrunと被るため大文字に変更
     let g:jedi#rename_command = '<Leader>R'
     " gundoと被るため大文字に変更 (2013-06-24 10:00 追記）
     "let g:jedi#goto_command = '<Leader>G'
     let g:jedi#goto_assignments_command = '<Leader>G'
   endfunction

   " vimfiler
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

     " .から始まるファイルおよび.pycで終わるファイルを不可視パターンに
     " 2013-08-14 追記
     let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"

     " vimfiler specific key mappings
     autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
     function! s:vimfiler_settings()
       " ^^ to go up
       nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
       " use R to refresh
       nmap <buffer> R <Plug>(vimfiler_redraw_screen)
       " overwrite C-l
       nmap <buffer> <C-l> <C-w>l
     endfunction
   endfunction
  "endfunction

  " w3m.vim
  NeoBundle 'yuratomo/w3m.vim'
  " NeoBundleLazy 'yuratomo/w3m.vim', {
  "     \ "autoload": {"filetypes": ['rst']}}
  " function! RestWatch()
  "     " TODO バックエンドで起動する
  "     " !restview -l 9999 . &
  "     " TODO 事前にプロセスとwindow情報を確認する。今は固定
  "     " let restview_pid = !pgrep -n -f restview
  "     " echo !lsof -Fc -a -i -p restview_pid
  "     :W3mSplit http://localhost:9999
  "     :wincmd L
  " endfunction

  " function! RestW3mReload()
  "     :wincmd w
  "     :W3mReload
  "     :wincmd w
  " endfunction
"  
" command! -nargs=0 RestWatch call RestWatch()
" command! -nargs=0 RestReload call RestW3mReload()
"  
" autocmd BufWritePost *.rst silent call RestW3mReload()

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
"function! s:InitNeoBundle()
"  if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
"    filetype plugin indent off
"    if has('vim_starting')
"      set runtimepath+=~/.vim/bundle/neobundle.vim/
"    endif
"    try
"      call neobundle#rc(expand('~/.vim/bundle/'))
"      call s:LoadBundles()
"    catch
"      call s:WithoutBundles()
"    endtry 
"  else
"    call s:WithoutBundles()
"  endif
"
"  filetype indent plugin on
"  syntax on
"endfunction

"call s:InitNeoBundle()

filetype indent plugin on
"#######################
" NERDTree
"#######################
"autocmd vimenter * if !argc() | NERDTree | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"
"nmap <silent> <C-e>      :NERDTreeToggle<CR>
"vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
"omap <silent> <C-e>      :NERDTreeToggle<CR>
"imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
"cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
"
"let g:NERDTreeShowHidden=1
"let g:NERDTreeDirArrows=0
"#######################
" Zen Coding
"#######################


let g:user_emmet_settings = {
  \  'lang' : 'ja',
  \  'eruby' : {
  \    'extends' : 'html',
  \    'indentation' : ' '
  \  },
  \  'html' : {
  \    'filters' : 'html',
  \    'indentation' : ' '
  \  },
  \  'perl' : {
  \    'indentation' : '  ',
  \    'aliases' : {
  \      'req' : "require '|'"
  \    },
  \    'snippets' : {
  \      'use' : "use strict\nuse warnings\n\n",
  \      'w' : "warn \"${cursor}\";",
  \    },
  \  },
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'html,c',
  \  },
  \  'scss' : {
  \    'indentation' : '  '
  \  },
  \  'css' : {
  \    'filters' : 'fc',
  \    'indentation' : '  '
  \  },
  \  'javascript' : {
  \    'snippets' : {
  \      'jq' : "$(function() {\n\t${cursor}${child}\n});",
  \      'jq:each' : "$.each(arr, function(index, item)\n\t${child}\n});",
  \      'fn' : "(function() {\n\t${cursor}\n})();",
  \      'tm' : "setTimeout(function() {\n\t${cursor}\n}, 100);",
  \    },
  \  },
  \ 'java' : {
  \  'indentation' : '    ',
  \  'snippets' : {
  \   'main': "public static void main(String[] args) {\n\t|\n}",
  \   'println': "System.out.println(\"|\");",
  \   'class': "public class | {\n}\n",
  \  },
  \ },
  \}

"####################
" vimproc
"####################
let g:quickrun_config = {}
let g:quickrun_config['*'] = {'runner': 'vimproc'}
"let g:quickrun_config['*'] = {'runner': 'vimproc', 'split':''}
"let g:quickrun_config['*'] = {'runmode': 'async:remote:vimproc', 'split': ''}
"let g:quickrun_config['*'] = {'runmode': 'async:remote:vimproc'}

" quickrunで開いたバッファを閉じる
nnoremap <Space>o :only<CR>
"###################
" neocomplcache
"###################
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
" Use neocomplcache.
"let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
"let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType c,cpp,perl set cindent
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
let g:neocomplcache_source_rank = {
  \ 'jscomplete' : 500,
  \ }
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplcache_omni_patterns.c =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:neocomplcache_omni_patterns.cpp =
\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl =
\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

