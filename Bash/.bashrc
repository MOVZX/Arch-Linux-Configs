#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL="erasedups:ignorespace"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# PS1='\u@\h:\w\$ '
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

ssh-add ~/.ssh/Root
ssh-add ~/.ssh/GitHub

# source ~/.mygit

export PATH="/usr/lib/ccache/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export CFLAGS+=' -O2 -march=znver4 -mtune=znver4'
export CXXFLAGS+=' -O2 -march=znver4 -mtune=znver4'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

source /usr/share/bash-complete-alias/complete_alias
source /usr/share/doc/find-the-command/ftc.bash noupdate info

complete -F _complete_alias "${!BASH_ALIASES[@]}"

eval "$(starship init bash)"

[[ ${BLE_VERSION-} ]] && ble-attach

clear
