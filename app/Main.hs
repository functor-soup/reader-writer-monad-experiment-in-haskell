module Main where

import Control.Monad.Reader
import Control.Monad.Writer
import qualified Data.Text as T
import Database.SQLite.Simple
import Lib

egg = (someFunc >> someFunc2)

main :: IO ()
main = do
  conn <- open "test.db"
  (a, w) <- runWriterT (runReaderT egg conn)
  putStrLn (T.unpack w)
