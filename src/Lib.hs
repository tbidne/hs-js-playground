module Lib
  ( hello,
    incCounter,
  )
where

import Data.IORef (IORef, modifyIORef', newIORef, readIORef)
import System.IO.Unsafe (unsafePerformIO)

hello :: String -> String
hello name = "Hello: " ++ name

counterRef :: IORef Int
counterRef = unsafePerformIO $ newIORef 0

{-# NOINLINE counterRef #-}

incCounter :: Int -> IO Int
incCounter inc = do
  counter <- readIORef counterRef
  modifyIORef' counterRef (+ inc)
  pure counter
