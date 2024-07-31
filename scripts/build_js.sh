if [[ -z $GHCJS_BIN ]]; then
  read -ep "Enter GHCJS_BIN dir (e.g. .../ghc/_build/stage1/bin): " input
  echo "This will be set next time if you ran this script via '. scripts/build.sh'"
  export GHCJS_BIN=$input
fi

GHC="$GHCJS_BIN/javascript-unknown-ghcjs-ghc"
GHC_PKG="$GHCJS_BIN/javascript-unknown-ghcjs-ghc-pkg"

BIN="./app/bin/ghcjs"

cabal build --with-compiler=$GHC --with-ghc-pkg=$GHC_PKG

if [[ -d "$BIN" ]]; then
  rm -r --interactive=never "$BIN"
fi

mkdir -p "$BIN"

cp -r ./dist-newstyle/build/javascript-ghcjs/ghc-*/hs-js-playground-*/x/hs-js-playground/opt/build/hs-js-playground/hs-js-playground.jsexe/* "$BIN"
