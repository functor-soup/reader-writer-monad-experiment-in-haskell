{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( someFunc
  , someFunc2
  ) where

import Control.Applicative
import Control.Monad.Reader
import Control.Monad.Writer
import qualified Data.Text as T
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow

data TestField =
  TestField Int
            String
  deriving (Show)

instance FromRow TestField where
  fromRow = TestField <$> field <*> field

type Custom a = ReaderT Connection (WriterT T.Text IO) a

someFunc :: Custom ()
someFunc = do
  conn <- ask
  lift $ tell "> initializing insert \n"
  let value = "test string 2"
  lift $ tell $ T.pack ("> Inserting value of " ++ value ++ "\n")
  liftIO $ execute conn "INSERT INTO test (str) VALUES (?)" (Only (value :: String))

someFunc2 :: Custom ()
someFunc2 = do
  conn <- ask
  lift $ tell "> Preparing to query stuff \n"
  r <- liftIO $ query_ conn "SELECT * from test" :: Custom [TestField]
  lift $ tell $ T.pack ("> queried info is " ++ show r ++ "\n")
  liftIO $ mapM_ print r
