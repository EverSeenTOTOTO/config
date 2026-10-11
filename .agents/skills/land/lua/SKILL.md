# lua — Lua 5.1.5 + lua-language-server

## Lua 5.1.5

Guard: `command -v lua`

```bash
wget https://www.lua.org/ftp/lua-5.1.5.tar.gz
tar -xvf lua-5.1.5.tar.gz
( cd lua-5.1.5 && make linux && sudo make install )   # announce the sudo step
rm -rf lua-5.1.5 lua-5.1.5.tar.gz
```

## lua-language-server

Guard: `command -v lua-language-server`

```bash
v=lua-language-server-3.6.23-linux-x64
mkdir -p ~/lua-ls && cd ~/lua-ls
wget "https://github.com/LuaLS/lua-language-server/releases/download/3.6.23/$v.tar.gz"
tar -xvf "$v.tar.gz"
rm -rf "$v" "$v.tar.gz"
```

Then append to `~/.exports.local` (only if absent — see the conventions in [../SKILL.md](../SKILL.md)):

```bash
export PATH="$HOME/lua-ls/bin:$PATH"
```
