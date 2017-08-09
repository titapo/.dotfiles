#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PROMPT FORMATTING
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

alias ls='ls -ltra --color=auto'
PS1='${GREEN}\u@\h \W${RESET}$ '

# ALLOW SCRIPTS TO BE EXECUTED BY 'perform command'
SCRIPTS_DIR=~/.scripts

perform()
{
    if [ -d $SCRIPTS_DIR ]; then
        bash $SCRIPTS_DIR/$1
    else
        echo "Cannot perform operation: directory does not exist: $SCRIPTS_DIR!"
    fi
}

# autocomplete
_performComplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(find $SCRIPTS_DIR | xargs -I {} basename {})" -- $cur) )
}

if [ -d $SCRIPTS_DIR ]; then
    complete -F _performComplete perform
fi
