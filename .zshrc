#complete
fpath=(path/to/zsh-completions/src /Users/kossy7 ~/.zsh/functions/Completion(N-/) ${fpath})

# zshのTAB補完を有効にする
#autoload -U compinit && compinit
autoload -U compinit; compinit -u
# 色設定
autoload -U colors; colors
export LSCOLORS=gxfxxxxxcxxxxxxxxxgxgx
export LS_COLORS='di=01;36:ln=01;35:ex=01;32'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'ex=32'
alias ls='ls -G'

export PATH=$PATH:/Library/Python/2.7/site-packages/bs4
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
#alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/mvim "$@"'
alias ios='open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'
# User specific aliases and functions

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

export PATH=$PATH:/usr/local/mysql/bin
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# For R
disable r


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
