#complete
fpath=(path/to/zsh-completions/src /Users/kossy7 ~/.zsh/functions/Completion(N-/) ${fpath})

# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -e

# zshのTAB補完を有効にする
#autoload -U compinit && compinit
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

export PATH=$PATH:/Library/Python/2.7/site-packages/bs4

# デフォルトのVimをMacVim Kaoriyaに
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias ios='open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'
# User specific aliases and functions
alias julia='/Applications/Julia-0.2.0-rc3.app/Contents/Resources/julia/bin/julia'

export PATH=/usr/local/bin:$PATH
#export PATH=/usr/local/share/python:$PATH
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
    source /usr/local/bin/virtualenvwrapper.sh
    export PIP_RESPECT_VIRTUALENV=true
fi
#export PATH = /usr/local/bin:/usr/local/share/python:$PATH
#export PATH=/usr/local/bin:$PATH
#export PATH=/usr/local/bin:/usr/local/share/python

#export PATH=$PATH:/usr/local/mysql/bin
export PATH="/usr/local/mysql/bin:$PATH"
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# For R
disable r

# javac の出力する文字コードをUTF-8に
# alias javac='javac -J-Dfile.encoding=UTF-8'
# alias java='java -Dfile.encoding=UTF-8'

# rvmによるRubyのインストール
# [[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


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
