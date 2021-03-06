##################################################################################
# 基本設定
##################################################################################
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#complete
fpath=(/usr/local/share/zsh-completions $fpath)
fpath+=~/.zfunc

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY

# Vi ライクな操作
#bindkey -v

# zshのTAB補完を有効にする
autoload -U compinit; compinit -u
# 色設定
autoload -U colors; colors

PROMPT='[%F{magenta}%B%n%b%f@%F{blue}%U%m%u%f]# '
RPROMPT='[%F{green}%d%f]'
# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# ↑に加えて、 .. とだけ入力したら1つ上のディレクトリに cd できるようにする
alias ..='cd ..'

# もっと増やしてもよい
alias ...='cd ../..'
alias ....='cd ../../..'

export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1 list-colors 'di=36' 'ln=35' 'ex=32'
#zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias ls='ls -G'

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="/usr/local/mysql/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


# 統計環境Rを使うため、最後に実行したコマンドを実行するコマンドr を使用不可に。
disable r

# javac の出力する文字コードをUTF-8に
# alias javac='javac -J-Dfile.encoding=UTF-8'
# alias java='java -Dfile.encoding=UTF-8'
##################################################################################
# cdr
##################################################################################
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*:*:cdr:*:*' menu selection
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default true
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/shell"
  zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
  zstyle ':chpwd:*' recent-dirs-pushd true
fi

##################################################################################
# hub
##################################################################################
function git(){hub "$@"} # zsh

##################################################################################
# direnv
##################################################################################
eval "$(direnv hook zsh)" 

##################################################################################
# tmux
##################################################################################
alias tmux='tmux -u'
# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
  tmux -u
fi

##################################################################################
# Python
##################################################################################
# # pip zsh completion start
# function _pip_completion {
#   local words cword
#   read -Ac words
#   read -cn cword
#   reply=( $( COMP_WORDS="$words[*]" \
#              COMP_CWORD=$(( cword-1 )) \
#              PIP_AUTO_COMPLETE=1 $words[1] ) )
# }
# compctl -K _pip_completion pip
# # pip zsh completion end

# pipenv shell の自動実行
function auto_pipenv_shell {
    if [ ! -n "${PIPENV_ACTIVE+1}" ]; then
        if [ -f "Pipfile" ] ; then
            pipenv shell
        fi
    fi
}

function cd {
    builtin cd "$@"
    auto_pipenv_shell
}

auto_pipenv_shell

##################################################################################
# Peco
##################################################################################
peco-select-history() {
    BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

peco-find-cd() {
 local FILENAME="$1"
 local MAXDEPTH="${2:-3}"
 local BASE_DIR="${3:-`pwd`}"

 if [ -z "$FILENAME" ] ; then
   echo "Usage: peco-find-cd <FILENAME> [<MAXDEPTH> [<BASE_DIR>]]" >&2
   return 1
 fi

 local DIR=$(find ${BASE_DIR} -maxdepth ${MAXDEPTH} -name ${FILENAME} | peco | head -n 1)

 if [ -n "$DIR" ] ; then
   DIR=${DIR%/*}
   echo "pushd \"$DIR\""
   pushd "$DIR"
 fi
}
function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^@' peco-cdr
#
# git add <file>の絞り込み
function peco-git-add() {
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
        peco --query "$LBUFFER" | \
        awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
      BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-git-add
bindkey '^g^a' peco-git-add

##################################################################################
# Enterでlsとgitを表示する
##################################################################################
#chpwd() {
#    ls_abbrev
#}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    #ls
    # ↓おすすめ
    ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

##################################################################################
# Ruby
##################################################################################
# rbenv
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# function gem(){
#     $HOME/.rbenv/shims/gem $*
#     if [ "$1" = "install" ] || [ "$1" = "i" ] || [ "$1" = "uninstall" ] || [ "$1" = "uni" ]
#     then
#         rbenv rehash
#     fi
# }
# 
# function bundle(){
#     $HOME/.rbenv/shims/bundle $*
#     if [ "$1" = "install" ] || [ "$1" = "update" ]
#     then
#         rbenv rehash
#     fi
# }

##################################################################################
# JavaScript
##################################################################################
export PATH=~/.npm-global/bin:$PATH
# export PATH="$PATH:`yarn global bin`"

##################################################################################
# Go
##################################################################################
export GOPATH=$HOME/dev
# export PATH=$PATH:$GOPATH/bin
# 
# # Glide
# export GO15VENDOREXPERIMENT=1

##################################################################################
# Dart
##################################################################################
export PATH=$HOME/study/dart/flutter/bin:$PATH

##################################################################################
# GCP
##################################################################################
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/naotokoshimizu/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/naotokoshimizu/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/naotokoshimizu/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/naotokoshimizu/google-cloud-sdk/completion.zsh.inc'; fi

##################################################################################
# OS別の読み込み
##################################################################################
case "${OSTYPE}" in
# MacOSX
darwin*)
    [ -f ~/dotfiles/.zshrc.osx ] && source ~/dotfiles/.zshrc.osx
    ;;
# Linux
linux*)
    [ -f ~/dotfiles/.zshrc.linux ] && source ~/dotfiles/.zshrc.linux
    ;;
esac

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/naotokoshimizu/Projects/casting_asia_aws_lambda/mobile_push_notification/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/naotokoshimizu/Projects/casting_asia_aws_lambda/mobile_push_notification/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/naotokoshimizu/Projects/casting_asia_aws_lambda/mobile_push_notification/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/naotokoshimizu/Projects/casting_asia_aws_lambda/mobile_push_notification/node_modules/tabtab/.completions/sls.zsh
