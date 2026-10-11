# zsh — Oh My Zsh, plugins, p10k, fzf, z

## Oh My Zsh

Guard: `[ -f ~/.oh-my-zsh/oh-my-zsh.sh ]`

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then, with `ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"`:

```bash
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  dir="$ZSH_CUSTOM/plugins/$plugin"
  [ -d "$dir" ] || git clone --depth 1 "https://github.com/zsh-users/$plugin" "$dir"
done

p10k="$ZSH_CUSTOM/themes/powerlevel10k"
[ -d "$p10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k"
```

`.zshrc` already references the plugins and the theme — nothing to edit after install.

## fzf

Guard: `[ -d ~/.fzf ]`

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

## z

Guard: `[ -f ~/.config/z.sh ]`

```bash
mkdir -p ~/.config
wget https://raw.githubusercontent.com/rupa/z/master/z.sh -P ~/.config
```
