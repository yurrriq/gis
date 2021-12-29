{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE ExplicitNamespaces #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Data.GIS where

import Data.Group (Group (..), (~~))
import Data.Isomorphism (embed)
import Data.Modular (toMod, ℤ, type (/))
import Data.Monoid (Sum (..))
import Data.Pitch
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic

class Group ivls => GIS space ivls | space -> ivls where
  ref :: space
  int :: space -> space -> ivls
  label :: space -> ivls

  default ref :: Monoid space => space
  ref = mempty

  int s t = label t ~~ label s

  default label :: Eq space => space -> ivls
  label s = if s == ref then mempty else int ref s

-- pc-space
instance GIS Chromatic.PitchClass (ℤ / 12) where
  ref = Chromatic.C
  label = embed (Chromatic.iso_z12)

-- p-space
instance GIS (Pitch Chromatic.PitchClass) (Sum Int) where
  ref = (Chromatic.C, 0)
  label (pc, oct) = Sum (fromEnum pc + 12 * oct)

instance GIS Diatonic.PitchClass (ℤ / 7) where
  ref = Diatonic.C
  label = toMod @7 . fromIntegral . fromEnum

instance GIS (Pitch Diatonic.PitchClass) (Sum Int) where
  ref = (Diatonic.C, 0)
  label (pc, oct) = Sum (fromEnum pc + 7 * oct)

instance Semigroup (ℤ / 12) where
  (<>) = (+)

instance Monoid (ℤ / 12) where
  mempty = 0

instance Group (ℤ / 12) where
  invert = negate

instance Semigroup (ℤ / 7) where
  (<>) = (+)

instance Monoid (ℤ / 7) where
  mempty = 0

instance Group (ℤ / 7) where
  invert = negate
