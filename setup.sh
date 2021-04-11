#!/usr/bin/bash
set -x
set -e

echo "copying dot files..."
ls -A | grep '^\.' | grep -v '^\.git$' | grep -v '^\.ssh' | xargs -I {} cp -r {} ~/

echo "installing tmux..."
echo "install oh my zsh"

#######################
# Oh-My-Zsh
#######################

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh --proxy $all_proxy)"

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

######################
# npm global
######################

if command -v npm >/dev/null 2>&1; then
  npm i -g dockerfile-language-server-nodejs
  npm i -g pm2
  npm i -g yarn
fi

