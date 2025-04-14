#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="risto"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

. ~/.oh-my-zsh/custom/plugins/zsh.command-not-found
#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#SYS#

#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#
export UBUNTU=$(lsb_release -r | awk '{print $2}')
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim
export MAIL="ugwentzi@student.42.fr"

alias firefox='/usr/lib/firefox/firefox'

eval "$(zoxide init zsh)"
/usr/bin/setxkbmap -option caps:escape
/usr/bin/xset r rate 300 50
umask 077
$HOME/.script/check_space_left.sh

#HE#HE#HE#HAAA#
[[ -e $HOME/Desktop/.shell_game.desktop ]] && rm -rf $HOME/Desktop/.shell_game.desktop
[[ -e $HOME/Desktop/.README ]] && rm -rf $HOME/Desktop/.README
[[ -e $HOME/Desktop/README ]] && rm -rf $HOME/Desktop/README
#HE#HE#HE#HAAA#

source $HOME/.zsh_aliases

#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#4#
