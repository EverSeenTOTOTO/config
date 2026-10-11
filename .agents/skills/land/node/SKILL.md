# node — npm globals + vue-ts5 shim

## Global packages

Guard per package against `npm ls -g --depth=0` output.

```bash
packages=(
  commitizen cz-conventional-changelog git-split-diffs pm2 stylelint-lsp typescript
  @biomejs/biome @vtsls/language-server @vue/language-server @vue/typescript-plugin
  vscode-langservers-extracted
)
installed=$(npm ls -g --depth=0)
for pkg in "${packages[@]}"; do
  echo "$installed" | grep -q "$pkg" || npm install -g "$pkg"
done
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

Note: `git-split-diffs` is the configured git pager — the [git](../git/SKILL.md) sub-skill only verifies it.

## vue-ts5 — TypeScript 5.x for vue_ls

TypeScript 7.x removed `tsserverlibrary.js`, which `@vue/language-server` depends on, and the global `typescript` resolves to 7.x. Keep a separate TS 5.x tree for vue_ls.

Guard: `[ -f ~/.vue-ls/vue-ts5/node_modules/typescript/lib/tsserverlibrary.js ]`

```bash
mkdir -p ~/.vue-ls/vue-ts5 && cd ~/.vue-ls/vue-ts5
npm init -y
npm install typescript@5
```

The nvim config (`lua/plugins/configs/lspconfig.lua`) points `vue_ls` at exactly this path — move it and nvim breaks.
