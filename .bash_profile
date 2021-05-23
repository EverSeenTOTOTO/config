# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
	[ -r "$file.local" ] && [ -f "$file.local" ] && source "$file.local";
done;
source /etc/profile;
unset file;
