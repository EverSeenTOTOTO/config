# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
	[ -r "$file.local" ] && [ -f "$file.local" ] && source "$file.local";
done;

source /etc/profile;
unset file;

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# autojump
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

export RISCV=/opt/riscv
export PYENV_ROOT="$HOME/.pyenv"

export PATH="$PYENV_ROOT/bin:$RISCV/bin:$PATH"

eval "$(pyenv init --path)"

# Set Windows codepage to 65001 (UTF-8).
if [[ "$OSTYPE" == "msys" ]]; then
    chcp.com 65001
fi
