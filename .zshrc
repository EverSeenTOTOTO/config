export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino-time"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
source $ZSH/oh-my-zsh.sh

