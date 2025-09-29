{-# LANGUAGE TemplateHaskellQuotes #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

module Data.Pitch.TH where

import Control.Monad (forM)
import Data.Pitch (Pitch (..))
import Language.Haskell.TH

genPitchPatterns :: Name -> Q [Dec]
genPitchPatterns tyName =
  do
    TyConI (DataD _ _ _ _ constructors _) <- reify tyName
    concat . concat
      <$> forM
        constructors
        ( \(NormalC conName []) ->
            forM octaves $ \oct ->
              let patName = mkName (nameBase conName ++ show oct)
                  patType = AppT (ConT ''Pitch) (ConT tyName)
                  patBody = ConP 'Pitch [] [TupP [ConP conName [] [], LitP (IntegerL (fromIntegral oct))]]
               in pure
                    [ PatSynSigD patName patType,
                      PatSynD patName (PrefixPatSyn []) ImplBidir patBody
                    ]
        )

octaves :: [Int]
octaves = [0 .. 10]
