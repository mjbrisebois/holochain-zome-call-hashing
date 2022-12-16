
pkg/package.json:		src/*.rs Makefile Cargo.toml
	wasm-pack build --scope whi --out-dir pkg --target nodejs
