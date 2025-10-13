{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

-- |
-- Module      : Data.PitchClass.Diatonic
-- Copyright   : (c) Eric Bailey, 2021-2025
--
-- License     : MIT
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : POSIX
--
-- Diatonic pc-space and p-space.
module Data.PitchClass.Diatonic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary (fromFinite, toFinite))
import Data.Finite (Finite)
import Data.GIS (IntervalOf)
import Data.Monoid (Sum)
import Data.Pitch (Pitch)
import Data.Pitch.TH (genPitchPatterns)
import GHC.Generics (Generic)

-- | The seven diatonic pitch classes.
data PitchClass = C | D | E | F | G | A | B
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Finitary)
  deriving
    ( -- | 'C₇' acts on 'PitchClass'
      Act C₇,
      -- | The 'C₇'-torsor where the action determines the interval
      -- ('Data.GIS.int')
      Torsor C₇
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

-- * Diatonic pc-space

-- | In diatonic pc-space, the seven [pitch classes]('PitchClass') can be
-- labeled by the elements of the cyclic group of order \(7\), 'C₇'.
type instance IntervalOf PitchClass = C₇

-- | The cyclic group of order \(7\), denoted
-- [\(C_{7}\)](https://people.maths.bris.ac.uk/~matyd/GroupNames/1/C7.html) or
-- [\(\mathbb{Z}_{7}\)](https://nathancarter.github.io/group-explorer/GroupInfo.html?groupURL=https://nathancarter.github.io/group-explorer/groups/Z_7.group).
type C₇ = Sum (Finite 7)

-- * Diatonic p-space

-- $doc
-- Pattern synonyms are defined for 'Data.PitchClass.Diatonic.C0' through
-- 'Data.PitchClass.Diatonic.B10'.

-- | In diatonic p-space, pitches can be labeled by the elements of the group of
-- integers under addition, \((\mathbb{Z}, +)\).
type instance IntervalOf (Pitch PitchClass) = Sum Int

$(genPitchPatterns ''PitchClass)
