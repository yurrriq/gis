{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

-- |
-- Module      : Data.PitchClass.Chromatic
-- Copyright   : (c) Eric Bailey, 2021-2025
--
-- License     : MIT
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : POSIX
--
-- Chromatic pc-space and p-space.
module Data.PitchClass.Chromatic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary (fromFinite, toFinite))
import Data.Finite (Finite)
import Data.GIS (IntervalOf)
import Data.Monoid (Sum)
import Data.Pitch (Pitch)
import Data.Pitch.TH (genPitchPatterns)
import GHC.Generics (Generic)

-- | The twelve chromatic pitch classes.
data PitchClass = C | Cis | D | Dis | E | F | Fis | G | Gis | A | Ais | B
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Finitary)
  deriving
    ( -- | 'C₁₂' acts on 'PitchClass'
      Act C₁₂,
      -- | The 'C₁₂'-torsor where the action determines the interval
      -- ('Data.GIS.int')
      Torsor C₁₂
    )
    via Finitely PitchClass

-- | Modular arithmetic. Only the 'fromInteger' function is supposed to be useful.
instance Num PitchClass where
  pcx + pcy = fromFinite (toFinite pcx + toFinite pcy)
  pcx - pcy = fromFinite (toFinite pcx - toFinite pcy)
  pcx * pcy = fromFinite (toFinite pcx * toFinite pcy)
  abs pc = pc
  signum _ = 1
  fromInteger x = fromFinite (fromInteger x)

-- * Chromatic pc-space

-- | In chromatic pc-space, the twelve [pitch classes]('PitchClass') can be
-- labeled by the elements of the cyclic group of order \(12\), 'C₁₂'.
type instance IntervalOf PitchClass = C₁₂

-- | The cyclic group of order \(12\), denoted
-- [\(C_{12}\)](https://people.maths.bris.ac.uk/~matyd/GroupNames/1/C12.html) or
-- [\(\mathbb{Z}_{12}\)](https://nathancarter.github.io/group-explorer/GroupInfo.html?groupURL=https://nathancarter.github.io/group-explorer/groups/Z_12.group).
type C₁₂ = Sum (Finite 12)

-- * Chromatic p-space

-- $doc
-- Pattern synonyms are defined for 'Data.PitchClass.Chromatic.C0' through
-- 'Data.PitchClass.Chromatic.B10'.

-- | In chromatic p-space, pitches can be labeled by the elements of the group
-- of integers under addition, \((\mathbb{Z}, +)\).
type instance IntervalOf (Pitch PitchClass) = Sum Int

$(genPitchPatterns ''PitchClass)
