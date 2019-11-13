let 
  pkgs = import ./nixpkgs.nix;
in 
  pkgs.haskell.packages.ghcjs.callCabal2nix "miso-example-app" ./. {}
