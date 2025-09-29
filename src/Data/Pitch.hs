{-# LANGUAGE DataKinds #-}

module Data.Pitch where

import Data.Finitary (Finitary)
import Data.Finite (Finite)
import Data.Monoid (Sum (..))

-- | Cyclic group of order 7.
type C₇ = Sum (Finite 7)

-- | Cyclic group of order 12.
type C₁₂ = Sum (Finite 12)

type Octave = Sum Int

newtype (Finitary a) => Pitch a = Pitch {getPitch :: (a, Octave)}

instance (Finitary a, Show a) => Show (Pitch a) where
  show (Pitch (pc, oct)) = show pc <> show (getSum oct)
