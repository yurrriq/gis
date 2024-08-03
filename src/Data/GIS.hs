{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE UndecidableSuperClasses #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Data.GIS where

import Data.Group (Group (..), (~~))
import Data.Isomorphism (Iso (..), embed)
import Data.Modular (Modulus, toMod, unMod, ℤ, type (/))
import Data.Monoid (Sum (..))
import Data.Pitch (Pitch)
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic

class (Group ivls) => GIS space ivls | space -> ivls where
  ref :: space
  int :: space -> space -> ivls
  label :: space -> ivls

  default ref :: (Monoid space) => space
  ref = mempty

  int s t = label t ~~ label s

  default label :: (Eq space) => space -> ivls
  label s = if s == ref then mempty else int ref s

-- pc-space
instance GIS Chromatic.PitchClass (ℤ / 12) where
  ref = Chromatic.C
  label = embed isoℤ

-- p-space
instance GIS (Pitch Chromatic.PitchClass) (Sum Int) where
  ref = (Chromatic.C, 0)
  label (pc, oct) = Sum (fromEnum pc + 12 * oct)

instance GIS Diatonic.PitchClass (ℤ / 7) where
  ref = Diatonic.C
  label = embed isoℤ

instance GIS (Pitch Diatonic.PitchClass) (Sum Int) where
  ref = (Diatonic.C, 0)
  label (pc, oct) = Sum (fromEnum pc + 7 * oct)

class (Enum space, Modulus n) => Isoℤ space n where
  isoℤ :: Iso (->) space (ℤ / n)
  isoℤ = Iso (toMod . fromIntegral . fromEnum) (toEnum . fromInteger . unMod)

instance Isoℤ Chromatic.PitchClass 12

instance Isoℤ Diatonic.PitchClass 7

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
