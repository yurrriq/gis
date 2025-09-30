{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Data.PitchClass.Chromatic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary (fromFinite, toFinite))
import Data.Finite (Finite)
import Data.GIS (GIS (label, ref), IntervalOf)
import Data.Monoid (Sum)
import Data.Pitch (Pitch, labelPitch)
import Data.Pitch.TH (genPitchPatterns)
import GHC.Generics (Generic)

data PitchClass = C | Cis | D | Dis | E | F | Fis | G | Gis | A | Ais | B
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Finitary)
  deriving (Act C₁₂, Torsor C₁₂) via Finitely PitchClass

-- | Cyclic group of order 12.
type C₁₂ = Sum (Finite 12)

type instance IntervalOf PitchClass = C₁₂

type instance IntervalOf (Pitch PitchClass) = Sum Int

$(genPitchPatterns ''PitchClass)

-- p-space
instance GIS (Pitch PitchClass) where
  ref = C0
  label = labelPitch

instance Num PitchClass where
  pcx + pcy = fromFinite (toFinite pcx + toFinite pcy)
  pcx - pcy = fromFinite (toFinite pcx - toFinite pcy)
  pcx * pcy = fromFinite (toFinite pcx * toFinite pcy)
  abs pc = pc
  signum _ = 1
  fromInteger x = fromFinite (fromInteger x)
