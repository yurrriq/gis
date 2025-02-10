{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UnicodeSyntax #-}

module Data.GIS where

import Data.Finitary (Cardinality, Finitary (..))
import Data.Finite (Finite)
import Data.Group (Group (..), (~~))
import Data.Monoid (Sum (..))
import Data.Pitch (Pitch (..))
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic

class (Group ivls) => GIS space ivls | space -> ivls where
  ref :: space
  int :: space -> space -> ivls
  label :: space -> ivls

  default ref :: (Bounded space) => space
  ref = minBound

  int s t = label t ~~ label s

  -- default label :: (Eq space) => space -> ivls
  -- label s = if s == ref then mempty else int ref s

  default label :: (Finitary space, Finitary ivls, Cardinality space ~ Cardinality ivls) => space -> ivls
  label = fromFinite . toFinite

-- | Cyclic group of order 7.
type ℤ₇ = Sum (Finite 7)

-- pc-space
instance GIS Diatonic.PitchClass ℤ₇

-- p-space
instance GIS (Pitch Diatonic.PitchClass) (Sum Int) where
  ref = Pitch (Diatonic.C, 0)
  label (Pitch (pc, oct)) = (fromEnum pc +) . (7 *) <$> oct

-- | Cyclic group of order 12.
type ℤ₁₂ = (Sum (Finite 12))

-- pc-space
instance GIS Chromatic.PitchClass ℤ₁₂

-- p-space
instance GIS (Pitch Chromatic.PitchClass) (Sum Int) where
  ref = Pitch (Chromatic.C, 0)
  label (Pitch (pc, oct)) = (fromEnum pc +) . (12 *) <$> oct
