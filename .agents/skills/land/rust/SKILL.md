# rust — rustup + cargo tools

Guard: `command -v cargo`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

Always run (idempotent on its own):

```bash
rustup component add rust-src clippy rust-analyzer
rustup target add wasm32-unknown-unknown
cargo install ripgrep lsd bat fd-find du-dust stylua cargo-expand
```
