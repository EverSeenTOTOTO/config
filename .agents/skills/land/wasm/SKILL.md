# wasm — wasmtime, wabt, wasi-sdk

## wasmtime

Guard: `[ -d ~/.wasmtime ]`

```bash
curl https://wasmtime.dev/install.sh -sSf | bash
```

## wabt

Guard: `[ -d ~/repos/wabt ]`

```bash
mkdir -p ~/repos/wabt && cd ~/repos/wabt
git clone --recursive https://github.com/WebAssembly/wabt .
git submodule update --init
mkdir build && cd build
cmake .. && cmake --build .
mv wa* ~/.wasmtime/bin    # move the built tools (wat2wasm, wasm2wat, …) only
```

Note: move only the `wa*` binaries, not the whole `build/` dir (CMake cache and objects live there too).

## wasi-sdk

Guard: `[ -d ~/repos/wasi ]`

```bash
mkdir -p ~/repos/wasi && cd ~/repos/wasi
git clone --recursive https://github.com/WebAssembly/wasi-sdk.git .
bash ci/build.sh
cmake --build build/toolchain --target dist
cmake --build build/sysroot --target dist
mkdir -p dist-my-platform
cp build/toolchain/dist/* build/sysroot/dist/* dist-my-platform
./ci/merge-artifacts.sh
```
