export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino-time"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file.local" ] && [ -f "$file.local" ] && source "$file.local";
done;
unset file;
source $ZSH/oh-my-zsh.sh

