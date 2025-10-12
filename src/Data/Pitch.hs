{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}

-- |
-- Module      : Data.Pitch
-- Copyright   : (c) Eric Bailey, 2021-2025
--
-- License     : MIT
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : POSIX
--
-- A pitch consists of a pitch class and an octave.
module Data.Pitch where

import Data.Bifoldable (bisum)
import Data.Bifunctor (bimap)
import Data.Finitary (Finitary (..))
import Data.Monoid (Sum (..))
import Data.Proxy (Proxy (..))
import GHC.TypeLits (natVal)

-- | A pitch consists of a pitch class and an octave.
newtype Pitch a = Pitch {getPitch :: (a, Octave)}

deriving instance (Bounded a) => Bounded (Pitch a)

deriving instance (Eq a) => Eq (Pitch a)

instance (Finitary a, Show a) => Show (Pitch a) where
  show = uncurry (<>) . bimap show show . getPitch

-- | An octave is an integer.
type Octave = Int

-- | Label a pitch with an element of the group of integers under addition.
labelPitch :: forall a. (Finitary a) => Pitch a -> Sum Int
labelPitch =
  Sum
    . bisum
    . bimap
      (fromIntegral . toFinite)
      (fromIntegral (natVal (Proxy @(Cardinality a))) *)
    . getPitch
