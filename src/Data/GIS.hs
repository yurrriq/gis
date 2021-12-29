{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExplicitNamespaces #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Data.GIS where

import Data.Group (Group (..), (~~))
import Data.Modular (toMod, ℤ, type (/))
import Data.Monoid (Sum (..))
import Data.Pitch
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic

data Group ivls => GIS space ivls = GIS
  { ref :: space,
    int :: space -> space -> ivls,
    label :: space -> ivls
  }

mkGIS :: Group ivls => space -> (space -> ivls) -> GIS space ivls
mkGIS ref' label' = GIS ref' int' label'
  where
    int' s t = label' t ~~ label' s

gisChromaticPitchClass, pcSpace :: GIS Chromatic.PitchClass (ℤ / 12)
gisChromaticPitchClass = mkGIS Chromatic.C (toMod @12 . fromIntegral . fromEnum)
pcSpace = gisChromaticPitchClass

gisChromaticPitch, pSpace :: GIS (Pitch Chromatic.PitchClass) (Sum Int)
gisChromaticPitch = mkGIS (Chromatic.C, 0) $ \(pc, oct) ->
  Sum (fromEnum pc + 12 * oct)
pSpace = gisChromaticPitch

instance Semigroup (ℤ / 12) where
  (<>) = (+)

instance Monoid (ℤ / 12) where
  mempty = 0

instance Group (ℤ / 12) where
  invert = negate

gisDiatonicPitchClass :: GIS Diatonic.PitchClass (ℤ / 7)
gisDiatonicPitchClass = mkGIS Diatonic.C (toMod @7 . fromIntegral . fromEnum)

gisDiatonicPitch :: GIS (Pitch Diatonic.PitchClass) (Sum Int)
gisDiatonicPitch = mkGIS (Diatonic.C, 0) $ \(pc, oct) ->
  Sum (fromEnum pc + 7 * oct)

instance Semigroup (ℤ / 7) where
  (<>) = (+)

instance Monoid (ℤ / 7) where
  mempty = 0

instance Group (ℤ / 7) where
  invert = negate
