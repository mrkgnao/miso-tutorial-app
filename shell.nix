let
  pkgs = import ./nixpkgs.nix;

  myghcEnv = pkgs.haskell.packages.ghc865.ghcWithPackages (ps: with ps; [ 
    hpack
    ghcid 

    aeson
    base
    bytestring
    containers
    http-types
    lens
    lucid
    miso
    network-uri
    servant
    servant-lucid
    servant-server
    stm
    transformers
    utf8-string
    vector
    wai
    wai-extra
    wai-logger
    warp

    beam-core 
    beam-postgres 
    beam-migrate 
    postgresql-simple
    resource-pool

    katip

    # jsaddle-warp
    # ghcjs-dom
    # ghcjs-dom-jsffi
    # jsaddle
    # QuickCheck
    # quickcheck-instances
  ]);
  
  myghcjsEnv = pkgs.haskell.packages.ghcjs86.ghcWithPackages (ps: with ps; [
    aeson
    containers
    bytestring
    lens
    ghcjs-base
    miso
    network-uri
    servant
    servant-client-core
    utf8-string
    servant-client-ghcjs

    beam-core 
    beam-postgres 
    beam-migrate
    # ghcjs-dom
    # ghcjs-dom-jsffi
    # jsaddle
    # jsaddle-warp
  ]);

  # myhie = pkgs.all-hies.bios.selection { selector = p: { inherit (p) ghc865; }; };

in 
  pkgs.stdenv.mkDerivation {
    name = "miso-example-app-env";
    src = ./.;
    buildInputs = [ 
      myghcEnv 
      myghcjsEnv 
    ];
    nativeBuildInputs = with pkgs; [ 
      cabal-install 
      # myhie
      entr
    ];
  }
