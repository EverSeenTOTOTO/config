ls -A | grep '^\.' | grep -v '^\.git$' | grep -v '^\.ssh' | xargs -I {} cp -r {} ~/
