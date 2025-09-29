{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}

module Data.PitchClass.Diatonic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary, fromFinite, toFinite)
import Data.Finite (Finite)
import Data.GIS (GIS (..))
import Data.Monoid (Sum (..))
import Data.Pitch (Pitch (..))
import Data.Pitch.TH (genPitchPatterns)
import GHC.Generics (Generic)

-- | Cyclic group of order 7.
type C₇ = Sum (Finite 7)

data PitchClass = C | D | E | F | G | A | B
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Finitary, GIS C₇)
  deriving (Act C₇, Torsor C₇) via Finitely PitchClass

$(genPitchPatterns ''PitchClass)

instance Num PitchClass where
  pcx + pcy = fromFinite (toFinite pcx + toFinite pcy)
  pcx - pcy = fromFinite (toFinite pcx - toFinite pcy)
  pcx * pcy = fromFinite (toFinite pcx * toFinite pcy)
  abs pc = pc
  signum _ = 1
  fromInteger x = fromFinite (fromInteger x)

instance Act (Sum Int) (Pitch PitchClass) where
  act n pitch@(Pitch (pc, Sum oct))
    | pc == minBound =
        let (q, r) = getSum n `divMod` 7
         in Pitch (act (fromIntegral r :: C₇) minBound, Sum (q + oct))
    | otherwise = act (n <> (Pitch (minBound, 0) --> pitch)) (Pitch (minBound, 0))

instance Torsor (Sum Int) (Pitch PitchClass) where
  from@(Pitch (pc, oct)) --> to@(Pitch (pc', oct'))
    | pc == minBound = (fromEnum pc' +) . (7 *) <$> (oct' - oct)
    | otherwise = (Pitch (minBound, 0) --> from :: Sum Int) --> (Pitch (minBound, 0) --> to :: Sum Int)

-- p-space
instance GIS (Sum Int) (Pitch PitchClass) where
  ref = Pitch (C, 0)
  label (Pitch (pc, oct)) = (fromEnum pc +) . (7 *) <$> oct
