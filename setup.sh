#!/usr/bin/bash
set -e

LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'
echo "copying dot files"
ls -A | grep '^\.' | grep -v '^\.git$' | grep -v '^\.ssh' | xargs -I % bash -c "echo -e '$LIGHT_GREEN%$NC'; cp -r % ~/"

echo "install oh my zsh"

#######################
# Oh-My-Zsh
#######################

if ! command -v zsh >/dev/null 2>&1; then
 sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

install_zsh_plugins() {
  ZSH_PLUG=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
  for plug in $@
  do
    echo -e "install zsh plugin $LIGHT_GREEN $plug $NC"
    if [[ ! -d $ZSH_PLUG/$plug ]]
    then
      git clone https://github.com/zsh-users/$plug $ZSH_PLUG/$plug -depth 1
    fi
  done
}

install_zsh_plugins zsh-autosuggestions zsh-syntax-highlighting

######################
# tmux
######################
# tpm
install_tmux_plugs() {
  TMUX_PLUG=~/.tmux/plugins
  for plug in $@
  do
    echo -e "install tpm plugin $LIGHT_GREEN $plug $NC"
    if [[ ! -d $TMUX_PLUG/$plug ]]; then
      git clone https://github.com/tmux-plugins/$plug $TMUX_PLUG/$plug
    fi
  done
}
install_tmux_plugs tpm tmux-resurrect tmux-battery tmux-cpu tmux-urlview tmux-open

######################
# npm global
######################
echo "install npm globals"
if command -v npm >/dev/null 2>&1; then
  for dep in dockerfile-language-server-nodejs pm2 yarn git-split-diffs
  do
    echo -e "install npm global dep $LIGHT_GREEN $dep $NC"
    npm i -g $dep
  done
else
  echo "skipped to install npm globals, you may installed by yourself."
fi

echo -e "\n$LIGHT_Blue DONE!$NC Don't forget to install:"
echo -e "\t$LIGHT_Blue fira-code fonts$NC: a geek font for coding"
echo -e "\t$LIGHT_Blue nerd-fonts$NC: for vim nerd icons"
echo -e "\t$LIGHT_Blue autojump$NC: faster jump between directories"

