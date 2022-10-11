# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
	[ -r "$file.local" ] && [ -f "$file.local" ] && source "$file.local";
done;

source /etc/profile;
unset file;

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# pyenv
# eval "$(pyenv init --path)"

# Set Windows codepage to 65001 (UTF-8).
if [[ "$OSTYPE" == "msys" ]]; then
    chcp.com 65001
fi

# z
. $HOME/.config/z.sh
