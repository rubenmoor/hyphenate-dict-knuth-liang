let
  pkgs = import <nixpkgs> { };
  syllables = pkgs.haskellPackages.callCabal2nix "hyphenate-dict" ./. { };

in 
  {
    withHls =
      with pkgs.haskellPackages;
      syllables.env.overrideAttrs ( oldAttrs: rec { 
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ haskell-language-server ];
      });
  }
