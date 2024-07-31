module Main (main) where

import GHC.JS.Foreign.Callback (Callback)
import GHC.JS.Foreign.Callback qualified as JS
import GHC.JS.Prim (JSVal)
import GHC.JS.Prim qualified as JS.Prim
import Lib qualified

-- Until we get first-class exports, a workaround is to use the FFI imports
-- to set the global state.

foreign import javascript "((f) => { hs_hello = f })"
  setHello :: Callback (JSVal -> IO JSVal) -> IO ()

foreign import javascript "((f) => { hs_incCounter = f })"
  setIncCounter :: Callback (JSVal -> IO JSVal) -> IO ()

main :: IO ()
main = do
  helloCallback <-
    JS.syncCallback1'
      (pure . JS.Prim.toJSString . Lib.hello . JS.Prim.fromJSString)

  incCounterCallback <-
    JS.syncCallback1'
      (fmap JS.Prim.toJSInt . Lib.incCounter . JS.Prim.fromJSInt)

  setHello helloCallback
  setIncCounter incCounterCallback
