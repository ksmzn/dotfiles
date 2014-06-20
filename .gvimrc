" Reload vimrc to overwrite OS default settings
let s:config_root = expand('~/.vim')
let s:bundle_root = s:config_root . '/bundle'

if isdirectory(s:bundle_root . '/Zenburn')
  colorscheme jellybeans
else
  colorscheme desert
endif

set guifontwide=Osaka:h12 "フォント設定
"set guifont=Osaka-Mono:h14 "フォント設定
set guifont=Ricty-RegularForPowerline:h14


highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/ "全角スペースを視覚化

set showtabline=2 "常にタブを表示

set transparency=3 "透明度を変更
map  gw :macaction selectNextWindow:
map  gW :macaction selectPreviousWindow:
" 縦幅 デフォルトは24
set lines=200
" 横幅 デフォルトは80
set columns=400
