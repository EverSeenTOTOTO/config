ls -A | grep '^\.' | grep -v '^\.git$' | xargs -I {} cp -r {} ~/

