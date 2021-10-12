{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad      (unless, when)
import           Data.Eq            ((==))
import           Data.Foldable      (for_)
import           Data.Function      (($))
import           Data.Functor       ((<$>))
import           Data.Monoid        ((<>))
import           Data.Text          (lines)
import qualified Data.Text          as Text
import           Data.Text.IO       (hGetContents, putStr, putStrLn)
import           GHC.Err            (error)
import           System.Environment (getArgs)
import           System.IO          (IO, IOMode (..), hSetNewlineMode, openFile,
                                     universalNewlineMode)
import           Text.Hyphenation   (german_1996, hyphenate)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [t, filename] -> do
      unless (t == "--file") usageError
      handle <- openFile filename ReadMode
      hSetNewlineMode handle universalNewlineMode
      ls <- lines <$> hGetContents handle
      for_ ls $ \l ->
        putStrLn $ l <> " " <> Text.intercalate "-" (Text.pack <$> hyphenate german_1996 (Text.unpack l))
    [word]        -> putStrLn $ Text.intercalate "-" $ Text.pack <$> hyphenate german_1996 word
    _             -> usageError

usageError :: IO ()
usageError =
  error "Usage: ./syllables --file german.utf8.dic\n\
        \or: ./syllables WORD"
