let
  holonixPath = builtins.fetchTarball { # main as of Sep 1, 2022
    url = "https://github.com/holochain/holonix/archive/a983ff292331d7553efadc5ab3916d5c2197dcee.tar.gz";
    sha256 = "0zpkw7wppdxl3pznkb39i7svfhg8pc0ly87n89sxsczj1fb17028";
  };
  holonix = import (holonixPath) {
    include = {
      holochainBinaries = true;
      node = false;
      scaffolding = false;
      happs = false;
    };

    rustVersion = {
      track = "stable";
      version = "1.63.0";
    };

    holochainVersionId = "custom";
    holochainVersion = {
      url = "https://github.com/holochain/holochain";
      rev = "c6bb672d624a884c57ffe588607ffc06aa2f7c74"; # Dec 13, 2022
      sha256 = "18qdmy71zdbwfvcbjb0nw27s4h28bgxc4998p3ipr58alx9rfiwy";
      cargoLock = {
        outputHashes = {
        };
      };

      binsFilter = [
        "holochain"
        "hc"
        # "kitsune-p2p-tx2-proxy"
      ];

      lair = {
        url = "https://github.com/holochain/lair";
        rev = "lair_keystore-v0.2.3"; # Dec 13, 2022 - cbfbefefe43073904a914c8181a450209a74167b
        sha256 = "011c0cng4h1vjb9wkjplhnpl6vnc41c8h8l4k6ldgc5k4ppap8vj";

        binsFilter = [
          "lair-keystore"
        ];

        cargoLock = {
          outputHashes = {
          };
        };
      };
    };
  };
  nixpkgs = holonix.pkgs;
in nixpkgs.mkShell {
  inputsFrom = [ holonix.main ];

  buildInputs = with nixpkgs; [
    wasm-bindgen-cli
    wasm-pack
    jq
  ];
}
