module Data.Pitch where

import Data.Finitary (Finitary)
import Data.Monoid (Sum (..))

type Octave = Sum Int

newtype (Finitary a) => Pitch a = Pitch {getPitch :: (a, Octave)}

instance (Finitary a, Show a) => Show (Pitch a) where
  show (Pitch (pc, oct)) = show pc <> show (getSum oct)
