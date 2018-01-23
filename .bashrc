#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PROMPT FORMATTING
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

alias ls='ls -ltra --color=auto'
PS1='\[${GREEN}\]\u@\h \W\[${RESET}\]$ '

# ALLOW SCRIPTS TO BE EXECUTED BY 'perform command'
export PERFORM_SCRIPTS_DIR=~/.scripts:~/.bscripts

perform()
{
  local executed=0
  for directory in $(echo $PERFORM_SCRIPTS_DIR | tr ":" "\n"); do
    if [ $executed == 1 ]; then
      break
    fi

    if [ -d $directory ]; then
      candidate=$directory/$1
      if [ -f $candidate ]; then
        bash $candidate "${@:2}"
        executed=1
      fi
    else
        echo "WARNING: Directory does not exist: $directory!"
    fi
  done

  if [ $executed == 0 ]; then
    echo "ERROR: Failed to execute $1!"
  fi
}

# autocomplete
_performComplete()
{
  local entries=""
  for directory in $(echo $PERFORM_SCRIPTS_DIR | tr ":" "\n"); do
    if [ -d $directory ]; then
      entries="$entries\n$(find $directory/ | xargs -I {} basename {})"
    fi
  done

  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$entries" -- $cur) )
}

complete -F _performComplete perform

export ZORP_LICENSE_FILE=/home/abel/stew/projects/scb-master/source/scb/zorp-core/tests/zts/license.txt
