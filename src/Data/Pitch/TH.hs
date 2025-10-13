{-# LANGUAGE TemplateHaskellQuotes #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

-- |
-- Module      : Data.Pitch.TH
-- Copyright   : (c) Eric Bailey, 2025
--
-- License     : MIT
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : POSIX
--
-- Template Haskell for creating pattern synonyms for 'Pitch'es.
module Data.Pitch.TH
  ( genPitchPatterns,
  )
where

import Control.Monad.Extra (concatForM)
import Data.Pitch (Pitch (..))
import Language.Haskell.TH
import Text.Printf (printf)

-- | Generate pattern synonyms from pitches of given pitch class for octaves @0@
-- through @10@.
genPitchPatterns :: Name -> Q [Dec]
genPitchPatterns tyName =
  do
    TyConI (DataD _ _ _ _ constructors _) <- reify tyName
    concatForM octaves $ \oct ->
      concatForM constructors $ \(NormalC conName []) ->
        let strCon = nameBase conName
            strName = strCon ++ show oct
            patName = mkName strName
         in sequence
              [ patSynSigD patName (appT (conT ''Pitch) (conT tyName)),
                patSynD_doc
                  patName
                  (prefixPatSyn [])
                  implBidir
                  ( conP
                      'Pitch
                      [ tupP
                          [ conP conName [],
                            litP (integerL (fromIntegral oct))
                          ]
                      ]
                  )
                  (Just (printf "> %s = Pitch (%s, %d)" strName strCon oct))
                  []
              ]

octaves :: [Int]
octaves = [0 .. 10]
