with (builtins.fromJSON (builtins.readFile ./nixpkgs.json));
let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  }) { 
    config.packageOverrides = overrides; 
    config.allowUnfree = true; 
  };

  inherit (pkgs.haskell.lib) enableCabalFlag sdistTarball buildStrictly;
  inherit (pkgs.haskell.packages) ghc865 ghcjs;
  inherit (pkgs.lib) overrideDerivation optionalString cleanSourceWith;
  inherit (pkgs) closurecompiler;

  miso-src = pkgs.fetchFromGitHub {
    owner = "dmjio";
    repo  = "miso";
    rev = "561ffade710ed9578b6bf83a6094fedeca9f666a";
    sha256 = "1wwzckz2qxb873wdkwqmx9gmh0wshcdxi7gjwkba0q51jnkfdi41";
  };

  jsaddle-src = pkgs.fetchFromGitHub {
    owner = "ghcjs";
    repo = "jsaddle";
    rev = "1e39844";
    sha256 = "1qrjrjagmrrlcalys33636w5cb67db52i183masb7xd93wir8963";
  };

  jsaddle-dom-src = pkgs.fetchFromGitHub {
    owner = "ghcjs";
    repo = "jsaddle-dom";
    rev = "6ce23c5";
    sha256 = "1wpwf025czibkw6770c99zk7r30j6nh7jdzhzqbi2z824qyqzbnw";
  };

  ghcjs-dom-src = pkgs.fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs-dom";
    rev = "b8e483a";
    sha256 = "06qlbbhjd0mlv5cymp5q0rb69a333l0fcif5zwa83h94dh25c1g7";
  };

  servant-src = pkgs.fetchFromGitHub {
    owner = "haskell-servant";
    repo = "servant";
    rev = "release-0.15";
    sha256 = "19by79r0xhz0ikf2m1rc8jysd273yi8cbvbsnad8yzl0j09ljnj2";
  };

  overrides = pkgs: with pkgs.haskell.lib; {
    haskell = pkgs.haskell // {
      packages = pkgs.haskell.packages // {
        ghc864 = pkgs.haskell.packages.ghc864.override {
          overrides = self: super: with pkgs.haskell.lib; {
            happy = dontCheck (super.callHackage "happy" "1.19.9" {});
            mkDerivation = args: super.mkDerivation (args // {
              enableLibraryProfiling = false;
              doCheck = false;
              doHaddock = false;
            });
          };
        };

        ghc865 = pkgs.haskell.packages.ghc865.override {
          overrides = self: super: with pkgs.haskell.lib; rec {
            jsaddle = self.callCabal2nix "jsaddle" "${jsaddle-src}/jsaddle" {};
            jsaddle-dom = self.callCabal2nix "jsaddle-dom" jsaddle-dom-src {};
            miso = self.callCabal2nix "miso" miso-src {};
            jsaddle-warp = dontCheck (self.callCabal2nix "jsaddle-warp" "${jsaddle-src}/jsaddle-warp" {});
            ghcjs-dom-jsaddle = self.callCabal2nix "ghcjs-dom-jsaddle" "${ghcjs-dom-src}/ghcjs-dom-jsaddle" {};
            ghcjs-dom-jsffi = self.callCabal2nix "ghcjs-dom-jsffi" "${ghcjs-dom-src}/ghcjs-dom-jsffi" {};
            ghcjs-dom = self.callCabal2nix "ghcjs-dom" "${ghcjs-dom-src}/ghcjs-dom" {};
          };
        };

        ghcjs86 = pkgs.haskell.packages.ghcjs86.override {
          overrides = self: super: with pkgs.haskell.lib; {
            mkDerivation = args: super.mkDerivation (args // { doCheck = false; });
            inherit (pkgs.haskell.packages.ghc865) hpack;
            miso = self.callCabal2nix "miso" miso-src {};
            jsaddle = self.callCabal2nix "jsaddle" "${jsaddle-src}/jsaddle" {};
            jsaddle-dom = self.callCabal2nix "jsaddle-dom" jsaddle-dom-src {};
            jsaddle-warp = dontCheck (self.callCabal2nix "jsaddle-warp" "${jsaddle-src}/jsaddle-warp" {});
            ghcjs-dom-jsaddle = self.callCabal2nix "ghcjs-dom-jsaddle" "${ghcjs-dom-src}/ghcjs-dom-jsaddle" {};
            ghcjs-dom-jsffi = self.callCabal2nix "ghcjs-dom-jsffi" "${ghcjs-dom-src}/ghcjs-dom-jsffi" {};
            ghcjs-dom = self.callCabal2nix "ghcjs-dom" "${ghcjs-dom-src}/ghcjs-dom" {};
            servant-client-ghcjs = doJailbreak (self.callCabal2nix "servant-client-ghcjs" "${servant-src}/servant-client-ghcjs" {});
            doctest = null;
          };
        };
      };
    };
  };
in
  pkgs
