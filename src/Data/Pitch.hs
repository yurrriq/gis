{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}

module Data.Pitch where

import Data.Bifoldable (bisum)
import Data.Bifunctor (bimap)
import Data.Finitary (Finitary (..))
import Data.Monoid (Sum (..))
import Data.Proxy (Proxy (..))
import GHC.TypeLits (natVal)

type Octave = Int

newtype (Finitary a) => Pitch a = Pitch {getPitch :: (a, Octave)}

deriving instance (Eq a) => Eq (Pitch a)

instance (Finitary a, Show a) => Show (Pitch a) where
  show = uncurry (<>) . bimap show show . getPitch

labelPitch :: forall a. (Finitary a) => Pitch a -> Sum Int
labelPitch =
  Sum
    . bisum
    . bimap
      (fromIntegral . toFinite)
      (fromIntegral (natVal (Proxy @(Cardinality a))) *)
    . getPitch
