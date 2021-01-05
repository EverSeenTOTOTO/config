# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file.local" ] && [ -f "$file.local" ] && source "$file.local";
done;
unset file;
