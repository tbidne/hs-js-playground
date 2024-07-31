<div align="center">

# hs-js-playground

[![MIT](https://img.shields.io/github/license/tbidne/hs-js-playground?color=blue)](https://opensource.org/licenses/MIT)

</div>

---

# Intro

This is an example project for playing with GHC's new native JS backend. Nix is not required in general, though it is assumed here.

The `flake.nix` provides two dev shells. The primary `default` exists for general development with `hls` and other dev tools. The second, `js`, exists solely to compile the JS artifacts. The fact that the `js` shell does not currently play nicely with our other dev tools is why we these are split into two shells.

# Building

## Non-JS

Enter the default shell with `nix develop` and run `cabal build`. This will build the project without creating any JS artifacts. This really just exists as a sanity check, and as a shell to launch your editor with `hls`. Note that this shell only works for the library, not the exe, because the exe requires GHC 9.10.

## JS

### Building the GHCJS compiler

If you already have a `ghcjs` compiler skip ahead. Otherwise, follow the instructions here: https://gitlab.haskell.org/ghc/ghc/-/wikis/javascript-backend/building

1. Enter nix shell:

    ```sh
    $ nix develop git+https://gitlab.haskell.org/ghc/ghc.nix#js-cross
    ```

2. Build the compiler:

    ```sh
    $ ./boot && emconfigure ./configure --target=javascript-unknown-ghcjs
    ```

    ```sh
    $ hadrian/build -j8 --flavour=quick --bignum=native --docs=none
    ```

### Building javascript app

1. With our `ghcjs` compiler in hand, once again enter the nix shell:

    ```sh
    $ nix develop .#js
    ```

    This is just the `ghc.nix` shell from above, as it includes necessary logic for handling emscripten's cache (by default, tries to use the immutable cache in the nix store, which will fail).

2. Run `. scripts/build_js.sh`. The first time this will prompt for your ghc's bin location. You don't _have_ to run the shell via dot-sourcing i.e. you can simply do `scripts/build_js.sh`. But sourcing it will save the `$GHCJS_BIN` dir for later runs.

3. Navigate to the `app/index.html` in your browser. You should see a bare html page with a couple buttons that use the compiled haskell functions. Congrats!
