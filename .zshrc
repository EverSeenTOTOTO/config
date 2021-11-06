export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino-time"

plugins=(git emoji extract docker-compose fd history zsh-autosuggestions zsh-syntax-highlighting)

unset file;

setopt +o nomatch

source $HOME/.bash_profile;
source $ZSH/oh-my-zsh.sh;

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
