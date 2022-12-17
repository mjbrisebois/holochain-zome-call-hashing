
FILE_PREFIX	= holochain_zome_call_hashing

build:				pkg/package.json

pkg/package.json:		src/*.rs Makefile Cargo.toml README.md
	wasm-pack build --scope whi --out-dir pkg --target bundler --release
	make pkg-nodejs/package.json && rm -rf pkg-nodejs

pkg-nodejs/package.json:	pkg/package.json
	wasm-pack build --scope whi --out-dir pkg-nodejs --target nodejs --release
	sed -i "s/$(FILE_PREFIX)/$(FILE_PREFIX)_node/"	\
		pkg-nodejs/package.json			\
		pkg-nodejs/$(FILE_PREFIX).js
	mv pkg-nodejs/$(FILE_PREFIX).js				pkg/$(FILE_PREFIX)_node.js
	mv pkg-nodejs/$(FILE_PREFIX).d.ts			pkg/$(FILE_PREFIX)_node.d.ts
	mv pkg-nodejs/$(FILE_PREFIX)_bg.wasm			pkg/$(FILE_PREFIX)_node_bg.wasm
	mv pkg-nodejs/$(FILE_PREFIX)_bg.wasm.d.ts		pkg/$(FILE_PREFIX)_node_bg.wasm.d.ts
	jq ".files += $$(jq .files pkg-nodejs/package.json)"	pkg/package.json	> package.json.1		\
	&& jq ".files += [\
		\"$(FILE_PREFIX)_bg.wasm.d.ts\",	\
		\"$(FILE_PREFIX).d.ts\"		\
	]"								package.json.1		> package.json.2	\
	&& jq ".files = $$(jq -S .files package.json.2)"		package.json.2		> package.json.3	\
	&& jq ".main = $$(jq .main pkg-nodejs/package.json)"		package.json.3		> package.json.4	\
	&& mv package.json.4 pkg/package.json && rm package.json.*


#
# Repository
#
clean-remove-chaff:
	@find . -name '*~' -exec rm {} \;
clean-files:		clean-remove-chaff
	git clean -nd
clean-files-force:	clean-remove-chaff
	git clean -fd
clean-files-all:	clean-remove-chaff
	git clean -ndx
clean-files-all-force:	clean-remove-chaff
	git clean -fdx


#
# NPM packaging
#
prepare-package:
	rm -f pkg/*
	make build
preview-package:	clean-files prepare-package
	cd pkg; npm pack --dry-run .
create-package:		clean-files prepare-package
	cd pkg; npm pack .
publish-package:	clean-files prepare-package
	cd pkg; npm publish --access public .
