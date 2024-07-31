{
  description = "A short demo of haskell's native JS backend.";

  inputs = {
    ###########
    #   Nix   #
    ###########

    # It would be great if we could share the same nixpkgs between our two
    # dev shells i.e.
    #
    #   nixpkgs.follows = "ghc_nix/nixpkgs";
    #
    # Alas, ghc_nix's nixpkgs does not seem to work with HLS i.e. attempting
    # to load it with nix-hs-utils produces errors. For now, we use different
    # hashes.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    ###########
    #  GHCJS  #
    ###########
    ghc_nix = {
      url = "git+https://gitlab.haskell.org/ghc/ghc.nix.git";
    };
    # We're not actually directly using this at the moment, but it can be
    # uncommented if needed.
    #ghc_nixpkgs.follows = "ghc_nix/nixpkgs";

    ###########
    #  Other  #
    ###########
    nix-hs-utils.url = "github:tbidne/nix-hs-utils";
  };

  outputs =
    inputs@{
      ghc_nix,
      nix-hs-utils,
      nixpkgs,
      self,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      hlib = pkgs.haskell.lib;
      ghc-version = "ghc982";
      compiler = pkgs.haskell.packages."${ghc-version}";
      compilerPkgs = {
        inherit compiler pkgs;
      };

      mkPkg =
        returnShellEnv:
        nix-hs-utils.mkHaskellPkg {
          inherit compiler pkgs returnShellEnv;
          name = "hs-js-playground";
          root = ./.;
        };
    in
    {
      devShells."${system}" = {
        # We provide two dev shells. The first, #default, is for primary
        # development. It's on ghc982 and provides haskell-language-server,
        # tools, etc.
        #
        # To actually build the javascript, we have another shell, #js.
        # Why not the same one? The #js shell is highly specialized for
        # building the javascript code and so far does not work with HLS.
        #
        # So for now these are different.
        default = mkPkg true;

        # It would be nice if could find a way to override the shellHook
        # to include our env var / script.
        js = ghc_nix.devShells."${system}".js-cross;
      };

      apps."${system}" = {
        format = nix-hs-utils.format compilerPkgs;
        lint = nix-hs-utils.lint compilerPkgs;
        lintRefactor = nix-hs-utils.lintRefactor compilerPkgs;
      };
    };
}
