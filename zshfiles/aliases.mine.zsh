# vim: set filetype=zsh
#        _ _
#   __ _| (_) __ _ ___  ___  ___
#  / _` | | |/ _` / __|/ _ \/ __|
# | (_| | | | (_| \__ \  __/\__ \
#  \__,_|_|_|\__,_|___/\___||___/
#
# written by Shotaro Fujimoto (https://github.com/ssh0)

#-------- Alias {{{
#------------------------------------------------------

# apt update
alias apt-upd='sudo apt-get update'

# apt upgrade
alias apt-upg='sudo apt-get upgrade'

# apt install
alias apt-ins='sudo apt-get install'

# urxvt -> urxvtc
alias urxvt='urxvtc'

# git alias to "g"
alias g='git'

# mplayer alias
alias mplayer='mplayer -msgcolor'

# colordiff
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# mkdocs
_mkdocs() {
    _arguments \
    {build}'[Build the MkDocs documentation]' \
    {gh-deploy}'[Deply your documentation to GitHub Pages]' \
    {json}'[Build the MkDocs documentation to JSON files...]' \
    {new}'[Create a new MkDocs project]' \
    {serve}'[Run the builtin development server]'
}
compdef _mkdocs mkdocs

#Enable verbose output
#Show the version and exit.
#Show this message and exit.
#
#
#
#
#
#
#
#
# }}}

#-------- extract images {{{
#------------------------------------------------------
function extract() {
    case $1 in
        *.tar.gz|*.tgz) tar xzvf $1;;
        *.tar.xz) tar Jxvf $1;;
        *.zip) unzip $1;;
        *.lzh) lha e $1;;
        *.tar.bz2|*.tbz) tar xjvf $1;;
        *.tar.Z) tar zxvf $1;;
        *.gz) gzip -d $1;;
        *.bz2) bzip2 -dc $1;;
        *.Z) uncompress $1;;
        *.tar) tar xvf $1;;
        *.arj) unarj $1;;
    esac
}
alias -s {qz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
alias -s {png,jpg,bmp,PNG,JPG,BMP}='eog'
# }}}
# -------- peco-history alias {{{
#------------------------------------------------------
function peco-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-select-history
# }}}
# -------- ranger-cd# {{{
# Compatible with ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp)"
    # for manual install
    /usr/local/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    # package install
    # /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# This binds Ctrl-O to ranger-cd:
# bind '"\C-o":"ranger-cd\C-m"'


# }}}
#-------- Start new ranger instance only if it's not running in current shell {{{
#------------------------------------------------------
# https://wiki.archlinux.org/index.php/Ranger#Start_new_ranger_instance_only_if_it.27s_not_running_in_current_shell
function r() {
    if [ -z "$RANGER_LEVEL" ]; then
        ranger-cd $@
    else
        exit
    fi
}
# }}}
#-------- zsh-bd # {{{
#------------------------------------------------------
# Quickly go back to aspecific parent directory instead of typing cd ../../../
# [Tarrasch/zsh-bd](https://github.com/Tarrasch/zsh-bd)

bd () {
  (($#<1)) && {
    print -- "usage: $0 <name-of-any-parent-directory>"
    print -- "       $0 <number-of-folders>"
    return 1
  } >&2
  local num=${#${(ps:/:)${PWD} }}
  local dest="./"

  # If the user provided an integer, go up as many times as asked
  if [[ "$1" = <-> ]]
  then
    if [[ $1 -gt $num ]]
    then
      print -- "bd: Error: Can not go up $1 times (not enough parent directories)"
      return 1
    fi
    for i in {1..$1}
    do
      dest+="../"
    done
    cd $dest
    return 0
  fi

  # else, find the correct parent directory
  # Get parents (in reverse order)
  local parents
  local i
  for i in {$((num+1))..2}
  do
    parents=($parents "$(echo $PWD | cut -d'/' -f$i)")
  done
  parents=($parents "/")
  # Build dest and 'cd' to it
  local parent
  foreach parent (${parents})
  do
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
    dest+="../"
  done
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}
_bd () {
  # Get parents (in reverse order)
  local num=${#${(ps:/:)${PWD}} }
  local i
  for i in {$((num+1))..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}
compctl -V directories -K _bd bd
# }}}

#-------- Configurations {{{
#------------------------------------------------------
cfg-aliases() { $EDITOR ~/.aliases.mine ;}
cfg-compton() { $EDITOR ~/.config/compton/compton.conf ;}
cfg-dotfiles() { $EDITOR ~/.dotfiles/setup_config_link ;}
cfg-latexmkrc() { $EDITOR ~/.latexmkrc }
cfg-mpv() { $EDITOR ~/.mpv/config ;}
cfg-mplayer() { $EDITOR ~/.mplayer/config ;}
cfg-ranger() { $EDITOR ~/.config/ranger/rc.conf ;}
cfg-ranger-rifle() { $EDITOR ~/.config/ranger/rifle.conf ;} # edit open_with extensions
cfg-ranger-commands() { $EDITOR ~/.config/ranger/commands.py ;} # scripts
cfg-tmux() { $EDITOR ~/.tmux.conf ;}
cfg-vimrc() { $EDITOR ~/.vimrc ;}
cfg-xdefaults() { $EDITOR ~/.Xdefaults ;}
# cfg-xinitrc() { $EDITOR ~/.xinitrc ;}
cfg-Xmodmap() { $EDITOR ~/.Xmodmap ;}
cfg-xmonad() { $EDITOR ~/.xmonad/xmonad.hs ;}
cfg-xresources() { $EDITOR ~/.Xresources ;}
cfg-zshrc() { $EDITOR ~/.zshrc.mine ;}
#}}}
#-------- Configurations Reload {{{
#------------------------------------------------------
rld-xdefaults() { xrdb ~/.Xdefaults ;}
rld-xmodmap() { xmodmap ~/.Xmodmap ;}
rld-xresources() { xrdb -load ~/.Xresources ;}
rld-zshrc() { source ~/.zshrc ;}
# }}}